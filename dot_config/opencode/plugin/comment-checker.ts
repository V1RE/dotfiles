import type { Plugin } from "@opencode-ai/plugin"

interface PendingCall {
  filePath: string
  content?: string
  oldString?: string
  newString?: string
  edits?: Array<{ old_string: string; new_string: string }>
  tool: "write" | "edit" | "multiedit"
  sessionID: string
  timestamp: number
}

interface HookInput {
  session_id: string
  tool_name: string
  transcript_path: string
  cwd: string
  hook_event_name: string
  tool_input: {
    file_path?: string
    content?: string
    old_string?: string
    new_string?: string
    edits?: Array<{ old_string: string; new_string: string }>
  }
}

const pendingCalls = new Map<string, PendingCall>()
const PENDING_CALL_TTL = 60_000

function cleanupOldPendingCalls(): void {
  const now = Date.now()
  for (const [callID, call] of pendingCalls) {
    if (now - call.timestamp > PENDING_CALL_TTL) {
      pendingCalls.delete(callID)
    }
  }
}

setInterval(cleanupOldPendingCalls, 10_000)

async function runCommentChecker(
  input: HookInput
): Promise<{ hasComments: boolean; message: string }> {
  const proc = Bun.spawn(["comment-checker"], {
    stdin: "pipe",
    stdout: "pipe",
    stderr: "pipe",
  })

  proc.stdin.write(JSON.stringify(input))
  proc.stdin.end()

  const stderr = await new Response(proc.stderr).text()
  const exitCode = await proc.exited

  if (exitCode === 2) {
    return { hasComments: true, message: stderr }
  }

  return { hasComments: false, message: "" }
}

export const CommentCheckerPlugin: Plugin = async (ctx) => {
  return {
    "tool.execute.before": async (
      input: { tool: string; sessionID: string; callID: string },
      output: { args: Record<string, unknown> }
    ): Promise<void> => {
      const toolLower = input.tool.toLowerCase()
      if (toolLower !== "write" && toolLower !== "edit" && toolLower !== "multiedit") {
        return
      }

      const filePath = (output.args.filePath ??
        output.args.file_path ??
        output.args.path) as string | undefined
      if (!filePath) return

      const content = output.args.content as string | undefined
      const oldString = (output.args.oldString ?? output.args.old_string) as string | undefined
      const newString = (output.args.newString ?? output.args.new_string) as string | undefined
      const edits = output.args.edits as
        | Array<{ old_string: string; new_string: string }>
        | undefined

      pendingCalls.set(input.callID, {
        filePath,
        content,
        oldString,
        newString,
        edits,
        tool: toolLower as "write" | "edit" | "multiedit",
        sessionID: input.sessionID,
        timestamp: Date.now(),
      })
    },

    "tool.execute.after": async (
      input: { tool: string; sessionID: string; callID: string },
      output: { title: string; output: string; metadata: unknown }
    ): Promise<void> => {
      const pendingCall = pendingCalls.get(input.callID)
      if (!pendingCall) return

      pendingCalls.delete(input.callID)

      // Skip if tool execution failed
      const outputLower = output.output.toLowerCase()
      if (
        outputLower.includes("error:") ||
        outputLower.includes("failed to") ||
        outputLower.includes("could not") ||
        outputLower.startsWith("error")
      ) {
        return
      }

      const hookInput: HookInput = {
        session_id: pendingCall.sessionID,
        tool_name: pendingCall.tool.charAt(0).toUpperCase() + pendingCall.tool.slice(1),
        transcript_path: "",
        cwd: ctx.directory,
        hook_event_name: "PostToolUse",
        tool_input: {
          file_path: pendingCall.filePath,
          content: pendingCall.content,
          old_string: pendingCall.oldString,
          new_string: pendingCall.newString,
          edits: pendingCall.edits,
        },
      }

      const result = await runCommentChecker(hookInput)

      if (result.hasComments && result.message) {
        output.output += `\n\n${result.message}`
      }
    },
  }
}
