import { createMemoryStore, type EmbedFn, type Memory, type MemoryStore } from "memelord"
import { tool, type Plugin } from "@opencode-ai/plugin"
import type { Event } from "@opencode-ai/sdk"
import { mkdirSync } from "node:fs"
import { join, resolve } from "node:path"

type UserInputSource = "user_denial" | "user_correction" | "user_input"

interface PendingToolCall {
  tool: string
  argsSummary: string
}

interface FailureState {
  count: number
  examples: string[]
  reported: boolean
}

interface SessionState {
  directory: string
  store?: MemoryStore
  injectedMemoryIDs: string[]
  assistantTexts: string[]
  recentAssistantTokens: number
  recentToolCalls: number
  recentErrors: number
  recentReads: number
  recentSearches: number
  recentEdits: number
  needsMaintenance: boolean
  lastFailureByTool: Map<string, { inputSummary: string; timestamp: number }>
  failuresByTool: Map<string, FailureState>
}

const schema = tool.schema
const sessions = new Map<string, SessionState>()
const pendingCalls = new Map<string, PendingToolCall>()
const dummyEmbed: EmbedFn = async () => new Float32Array(384)
const RECENT_FAILURE_WINDOW_MS = 2 * 60 * 1000
const HIGH_TOKEN_THRESHOLD = 20_000

let cachedEmbedder: EmbedFn | undefined

function ensureDataDir(directory: string): string {
  const dataDir = join(directory, ".memelord")
  mkdirSync(dataDir, { recursive: true })
  return dataDir
}

function getDbPath(directory: string): string {
  return resolve(ensureDataDir(directory), "memory.db")
}

function getSessionState(sessionID: string, directory: string): SessionState {
  const existing = sessions.get(sessionID)
  if (existing) {
    existing.directory = directory
    return existing
  }

  const created: SessionState = {
    directory,
    injectedMemoryIDs: [],
    assistantTexts: [],
    recentAssistantTokens: 0,
    recentToolCalls: 0,
    recentErrors: 0,
    recentReads: 0,
    recentSearches: 0,
    recentEdits: 0,
    needsMaintenance: false,
    lastFailureByTool: new Map(),
    failuresByTool: new Map(),
  }
  sessions.set(sessionID, created)
  return created
}

async function createEmbedder(): Promise<EmbedFn> {
  if (cachedEmbedder) return cachedEmbedder

  const { pipeline } = await import("@huggingface/transformers")
  const extractor = await pipeline(
    "feature-extraction",
    process.env.MEMELORD_MODEL ?? "Xenova/all-MiniLM-L6-v2",
    {
      quantized: true,
    },
  )

  cachedEmbedder = async (text: string) => {
    const output = await extractor(text, { pooling: "mean", normalize: true })
    return new Float32Array(output.data)
  }

  return cachedEmbedder
}

async function getStore(sessionID: string, directory: string): Promise<MemoryStore> {
  const session = getSessionState(sessionID, directory)
  if (session.store) return session.store

  const store = createMemoryStore({
    dbPath: getDbPath(directory),
    sessionId: sessionID,
    embed: await createEmbedder(),
  })
  await store.init()
  session.store = store
  return store
}

async function withLightStore<T>(sessionID: string, directory: string, fn: (store: MemoryStore) => Promise<T>): Promise<T> {
  const store = createMemoryStore({
    dbPath: getDbPath(directory),
    sessionId: sessionID,
    embed: dummyEmbed,
  })
  await store.init()
  try {
    return await fn(store)
  } finally {
    await store.close()
  }
}

function stringify(value: unknown): string {
  try {
    const text = typeof value === "string" ? value : JSON.stringify(value)
    return text.length > 200 ? `${text.slice(0, 200)}...` : text
  } catch {
    return "[unserializable input]"
  }
}

function formatMemories(memories: ReadonlyArray<Memory>): string {
  if (memories.length === 0) {
    return "No relevant memories found. This appears to be a new type of task."
  }

  const lines = [`Retrieved ${memories.length} relevant memories:`, ""]
  for (const memory of memories) {
    lines.push(
      `--- [${memory.category}] (weight: ${memory.weight.toFixed(2)}, score: ${memory.score.toFixed(3)}) ---`,
      memory.content,
      "",
    )
  }
  return lines.join("\n")
}

function systemContext(memories: ReadonlyArray<Memory>): string {
  const lines: string[] = []

  if (memories.length > 0) {
    lines.push("# Memories from past sessions", "")
    for (const memory of memories) {
      lines.push(
        `[${memory.category}] (id: ${memory.id}, weight: ${memory.weight.toFixed(2)})`,
        memory.content,
        "",
      )
    }
  }

  lines.push(
    "# Memory system instructions",
    "",
    "You have a persistent memory system available as native tools.",
    "",
    "1. At the START of every task, call memory_start_task with the user's request.",
    "2. When you self-correct, call memory_report with type \"correction\".",
    "3. When the user corrects you, call memory_report with type \"user_input\".",
    "4. When you discover reusable project knowledge, call memory_report with type \"insight\".",
    "5. If a retrieved memory is wrong, call memory_contradict with its id and the correction.",
    "6. When you finish a task, call memory_end_task and rate retrieved memories 0-3.",
  )

  return lines.join("\n")
}

function isFailureOutput(output: string): boolean {
  const text = output.toLowerCase()
  return (
    text.startsWith("error") ||
    text.includes("error:") ||
    text.includes("failed to") ||
    text.includes("could not") ||
    text.includes("permission denied") ||
    text.includes("command not found") ||
    text.includes("no such file") ||
    text.includes("enoent")
  )
}

function scoreAssistantTokens(event: Event): number {
  if (event.type !== "message.updated") return 0
  const info = event.properties.info
  if (info.role !== "assistant") return 0

  return info.tokens.input + info.tokens.output + info.tokens.reasoning + info.tokens.cache.write
}

function trackToolCategory(session: SessionState, toolName: string): void {
  const normalized = toolName.toLowerCase()

  if (normalized === "read") {
    session.recentReads += 1
    return
  }

  if (normalized === "glob" || normalized === "grep" || normalized === "lsp") {
    session.recentSearches += 1
    return
  }

  if (normalized === "edit" || normalized === "write" || normalized === "multiedit" || normalized === "apply_patch") {
    session.recentEdits += 1
  }
}

function maybeStoreAssistantText(session: SessionState, event: Event): void {
  if (event.type !== "message.part.updated") return

  const part = event.properties.part
  if (part.type !== "text") return
  if (part.text.length < 80) return

  session.assistantTexts.push(part.text)
  if (session.assistantTexts.length > 12) {
    session.assistantTexts.shift()
  }
}

function buildDiscoverySummary(texts: ReadonlyArray<string>): string | undefined {
  if (texts.length === 0) return undefined

  const longest = [...texts].sort((left, right) => right.length - left.length).slice(0, 5)
  const combined = new Set([...longest, ...texts.slice(-2)])
  const summary = texts
    .filter((text) => combined.has(text))
    .map((text) => text.slice(0, 500))
    .join("\n\n")
    .slice(0, 2000)

  return summary.length >= 100 ? summary : undefined
}

async function handleAutoFailure(
  sessionID: string,
  directory: string,
  toolName: string,
  argsSummary: string,
  output: string,
): Promise<void> {
  const session = getSessionState(sessionID, directory)
  const failure = session.failuresByTool.get(toolName) ?? {
    count: 0,
    examples: [],
    reported: false,
  }

  failure.count += 1
  if (failure.examples.length < 2) {
    const summary = output.length > 100 ? `${output.slice(0, 100)}...` : output
    failure.examples.push(summary)
  }
  session.failuresByTool.set(toolName, failure)
  session.lastFailureByTool.set(toolName, { inputSummary: argsSummary, timestamp: Date.now() })

  if (failure.count >= 3 && !failure.reported) {
    const examples = failure.examples.join("; ")
    await withLightStore(sessionID, directory, async (store) => {
      await store.insertRawMemory(`Repeated failures with ${toolName} (${failure.count}x in session): ${examples}`, "correction", 1.0)
    })
    failure.reported = true
    session.needsMaintenance = true
  }
}

async function handleAutoSuccess(sessionID: string, directory: string, toolName: string, argsSummary: string): Promise<void> {
  const session = getSessionState(sessionID, directory)
  const lastFailure = session.lastFailureByTool.get(toolName)
  const failure = session.failuresByTool.get(toolName)

  if (lastFailure && lastFailure.inputSummary !== argsSummary && Date.now() - lastFailure.timestamp <= RECENT_FAILURE_WINDOW_MS) {
    await withLightStore(sessionID, directory, async (store) => {
      await store.insertRawMemory(
        `Auto-detected correction with ${toolName}:\n\nFailed approach: ${lastFailure.inputSummary}\nWorking approach: ${argsSummary}`,
        "correction",
        1.5,
      )
    })
    session.needsMaintenance = true
  }

  session.lastFailureByTool.delete(toolName)
  if (failure) {
    failure.count = 0
    failure.examples = []
    failure.reported = false
  }
}

async function runMaintenance(sessionID: string): Promise<void> {
  const session = sessions.get(sessionID)
  if (!session) return
  if (!session.needsMaintenance && session.recentAssistantTokens < HIGH_TOKEN_THRESHOLD) return

  const store = await getStore(sessionID, session.directory)
  await store.embedPending()

  const explorationCount = session.recentReads + session.recentSearches
  const totalTrackedTools = explorationCount + session.recentEdits
  const explorationRatio = totalTrackedTools === 0 ? 0 : explorationCount / totalTrackedTools
  const summary = buildDiscoverySummary(session.assistantTexts)

  if (session.recentAssistantTokens >= 50_000 && explorationRatio > 0.5 && summary) {
    await store.insertRawMemory(
      `[Discovery after ${Math.round(session.recentAssistantTokens / 1000)}k tokens, ${session.recentToolCalls} tool calls]\n\n${summary}`,
      "discovery",
      1.0,
    )
  }

  if (session.injectedMemoryIDs.length > 0 && session.recentAssistantTokens >= HIGH_TOKEN_THRESHOLD) {
    for (const memoryID of session.injectedMemoryIDs) {
      await store.penalizeMemory(memoryID, 0.999)
    }
  }

  await store.decay()
  session.needsMaintenance = false
  session.recentAssistantTokens = 0
  session.recentToolCalls = 0
  session.recentErrors = 0
  session.recentReads = 0
  session.recentSearches = 0
  session.recentEdits = 0
  session.assistantTexts = []
}

export const MemelordPlugin: Plugin = async (input) => {
  const projectDirectory = input.directory
  const memoryStartTask = tool({
    description:
      "Start a new task and retrieve relevant memories. You MUST call this FIRST at the beginning of every task, before doing any work.",
    args: {
      description: schema.string().describe("The user's request or task description"),
    },
    async execute(args, context) {
      const store = await getStore(context.sessionID, context.directory)
      const result = await store.startTask(args.description)
      return `Task started (id: ${result.taskId})\n\n${formatMemories(result.memories)}`
    },
  })

  const memoryReport = tool({
    description:
      "Report a self-correction, user-provided knowledge, or codebase insight to persist across sessions.",
    args: {
      type: schema.enum(["correction", "user_input", "insight"] as const).describe("What kind of memory to store"),
      lesson: schema.string().describe("The lesson learned"),
      what_failed: schema.string().optional().describe("Correction only: what failed"),
      what_worked: schema.string().optional().describe("Correction only: what worked"),
      tokens_wasted: schema.number().int().nonnegative().optional().describe("Correction only: approximate tokens wasted"),
      tools_wasted: schema.number().int().nonnegative().optional().describe("Correction only: approximate tool calls wasted"),
      source: schema.enum(["user_denial", "user_correction", "user_input"] as const).optional().describe("User input only: how the user provided it"),
    },
    async execute(args, context) {
      const store = await getStore(context.sessionID, context.directory)
      const session = getSessionState(context.sessionID, context.directory)
      let id = ""

      if (args.type === "correction") {
        id = await store.reportCorrection({
          lesson: args.lesson,
          whatFailed: args.what_failed ?? "",
          whatWorked: args.what_worked ?? "",
          tokensWasted: args.tokens_wasted,
          toolsWasted: args.tools_wasted,
        })
      } else if (args.type === "user_input") {
        const source: UserInputSource = args.source ?? "user_input"
        id = await store.reportUserInput({
          lesson: args.lesson,
          source,
        })
      } else {
        id = await store.insertRawMemory(args.lesson, "insight", 1.0)
      }

      session.needsMaintenance = true
      return `Memory saved (id: ${id}). This will be remembered across sessions.`
    },
  })

  const memoryEndTask = tool({
    description:
      "End the current task, record outcome metrics, and update memory weights. You MUST call this when a task is complete.",
    args: {
      task_id: schema.string().describe("The task id returned by memory_start_task"),
      tokens_used: schema.number().int().nonnegative().describe("Total tokens used during this task"),
      tool_calls: schema.number().int().nonnegative().describe("Total tool calls made during this task"),
      errors: schema.number().int().nonnegative().describe("Number of errors encountered"),
      user_corrections: schema.number().int().nonnegative().describe("How many times the user corrected you"),
      completed: schema.boolean().describe("Whether the task completed successfully"),
      self_report: schema
        .array(
          schema.object({
            memory_id: schema.string(),
            score: schema.number().int().min(0).max(3),
          }),
        )
        .optional()
        .describe("Rate each retrieved memory: 0=ignored, 3=directly applied"),
    },
    async execute(args, context) {
      const store = await getStore(context.sessionID, context.directory)
      await store.endTask(args.task_id, {
        tokensUsed: args.tokens_used,
        toolCalls: args.tool_calls,
        errors: args.errors,
        userCorrections: args.user_corrections,
        completed: args.completed,
        selfReport: args.self_report?.map((entry) => ({
          memoryId: entry.memory_id,
          score: entry.score,
        })),
      })

      await store.embedPending()
      await store.decay()

      const session = getSessionState(context.sessionID, context.directory)
      session.needsMaintenance = false
      return "Task completed. Memory weights updated successfully."
    },
  })

  const memoryContradict = tool({
    description:
      "Flag a retrieved memory as incorrect, remove it, and optionally save the corrected replacement.",
    args: {
      memory_id: schema.string().describe("The incorrect memory id"),
      correction: schema.string().optional().describe("Replacement memory content to store"),
    },
    async execute(args, context) {
      const store = await getStore(context.sessionID, context.directory)
      const result = await store.contradictMemory(args.memory_id, args.correction)

      if (!result.deleted) {
        return "No memory was deleted. The memory id may already be gone."
      }

      if (result.correctionId) {
        return `Memory deleted. Stored correction as ${result.correctionId}.`
      }

      return "Memory deleted successfully."
    },
  })

  const memoryStatus = tool({
    description: "Show memory system statistics and top memories.",
    args: {},
    async execute(_args, context) {
      const store = await getStore(context.sessionID, context.directory)
      const stats = await store.getStats()
      const lines = [
        `Total memories: ${stats.totalMemories}`,
        `Tasks: ${stats.taskCount}`,
        `Average task score: ${stats.avgTaskScore.toFixed(3)}`,
      ]

      if (stats.topMemories.length > 0) {
        lines.push("", "Top memories:")
        for (const memory of stats.topMemories.slice(0, 5)) {
          const preview = memory.content.length > 120 ? `${memory.content.slice(0, 120)}...` : memory.content
          lines.push(`- [w=${memory.weight.toFixed(2)}, used=${memory.retrievalCount}x] ${preview}`)
        }
      }

      return lines.join("\n")
    },
  })

  return {
    tool: {
      memory_start_task: memoryStartTask,
      memory_report: memoryReport,
      memory_end_task: memoryEndTask,
      memory_contradict: memoryContradict,
      memory_status: memoryStatus,
    },

    async event(input) {
      const event = input.event
      if (event.type === "message.updated") {
        const info = event.properties.info
        const session = getSessionState(info.sessionID, info.path.cwd)
        session.recentAssistantTokens += scoreAssistantTokens(event)
        return
      }

      if (event.type === "message.part.updated") {
        const session = getSessionState(event.properties.part.sessionID, projectDirectory)
        maybeStoreAssistantText(session, event)
        return
      }

      if (event.type === "session.idle") {
        await runMaintenance(event.properties.sessionID)
        return
      }

      if (event.type === "session.deleted") {
        const session = sessions.get(event.properties.info.id)
        if (session?.store) await session.store.close()
        sessions.delete(event.properties.info.id)
      }
    },

    async "experimental.chat.system.transform"(input, output) {
      const sessionID = input.sessionID
      if (!sessionID) return

      const memories = await withLightStore(sessionID, projectDirectory, async (store) => store.getTopByWeight(5))
      const session = getSessionState(sessionID, projectDirectory)
      session.injectedMemoryIDs = memories.map((memory) => memory.id)
      output.system.push(systemContext(memories))
    },

    async "tool.execute.before"(input, output) {
      if (input.tool.startsWith("memory_")) return

      pendingCalls.set(input.callID, {
        tool: input.tool,
        argsSummary: stringify(output.args),
      })

      const session = getSessionState(input.sessionID, projectDirectory)
      session.recentToolCalls += 1
      trackToolCategory(session, input.tool)
    },

    async "tool.execute.after"(input, output) {
      const pending = pendingCalls.get(input.callID)
      pendingCalls.delete(input.callID)
      if (!pending) return

      const session = getSessionState(input.sessionID, projectDirectory)
      const failed = isFailureOutput(output.output)

      if (failed) {
        session.recentErrors += 1
        await handleAutoFailure(input.sessionID, session.directory, pending.tool, pending.argsSummary, output.output)
        return
      }

      await handleAutoSuccess(input.sessionID, session.directory, pending.tool, pending.argsSummary)
    },
  }
}

export default MemelordPlugin
