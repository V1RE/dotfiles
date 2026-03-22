import type { ExtensionAPI, ExtensionContext } from "@mariozechner/pi-coding-agent";
import { isToolCallEventType } from "@mariozechner/pi-coding-agent";

type ReadonlyCommandGroup = {
  readonly name: string;
  readonly allow: readonly RegExp[];
};

const DIRECTLY_BLOCKED = [/^(?:lazygit|lg|tig|gitui|forgit|hub|lab|glab)(?:\s|$)/i] as const;

const READONLY_GROUPS: readonly ReadonlyCommandGroup[] = [
  {
    name: "git",
    allow: [
      /^git\s+status(?:\s|$)/i,
      /^git\s+log(?:\s|$)/i,
      /^git\s+show(?:\s|$)/i,
      /^git\s+diff(?:\s|$)/i,
      /^git\s+blame(?:\s|$)/i,
      /^git\s+annotate(?:\s|$)/i,
      /^git\s+branch(?:\s+-v(?:\s|$)|\s+--list(?:\s|$)|\s+--show-current(?:\s|$)|\s*$)/i,
      /^git\s+tag\s+(?:-l|--list|-v)(?:\s|$)/i,
      /^git\s+remote\s+(?:-v|show|get-url)(?:\s|$)/i,
      /^git\s+ls-(?:files|tree|remote)(?:\s|$)/i,
      /^git\s+rev-(?:parse|list)(?:\s|$)/i,
      /^git\s+describe(?:\s|$)/i,
      /^git\s+shortlog(?:\s|$)/i,
      /^git\s+whatchanged(?:\s|$)/i,
      /^git\s+grep(?:\s|$)/i,
      /^git\s+fetch(?:\s|$)/i,
      /^git\s+archive(?:\s|$)/i,
      /^git\s+format-patch(?:\s|$)/i,
      /^git\s+stash\s+(?:list|show)(?:\s|$)/i,
      /^git\s+config\s+(?:--list|--get|-l)(?:\s|$)/i,
      /^git\s+(?:help|--help|version|--version)(?:\s|$)/i,
      /^git\s+cat-file(?:\s|$)/i,
      /^git\s+show-(?:ref|branch)(?:\s|$)/i,
      /^git\s+for-each-ref(?:\s|$)/i,
      /^git\s+name-rev(?:\s|$)/i,
      /^git\s+merge-base(?:\s|$)/i,
      /^git\s+verify-(?:commit|tag)(?:\s|$)/i,
      /^git\s+fsck(?:\s|$)/i,
      /^git\s+count-objects(?:\s|$)/i,
      /^git\s+check-(?:ignore|attr)(?:\s|$)/i,
      /^git\s+reflog\s+(?:show|list)(?:\s|$)/i,
      /^git\s+notes\s+(?:list|show)(?:\s|$)/i,
      /^git\s+worktree\s+list(?:\s|$)/i,
      /^git\s+submodule\s+(?:status|summary)(?:\s|$)/i,
      /^git\s+bundle\s+(?:verify|list-heads)(?:\s|$)/i,
      /^git\s+sparse-checkout\s+list(?:\s|$)/i,
      /^git\s+cherry(?:\s|$)/i,
      /^git\s+range-diff(?:\s|$)/i
    ]
  },
  {
    name: "gh",
    allow: [
      /^gh\s+pr\s+(?:view|list|status|checks|diff)(?:\s|$)/i,
      /^gh\s+issue\s+(?:view|list|status|create)(?:\s|$)/i,
      /^gh\s+repo\s+(?:view|list|clone)(?:\s|$)/i,
      /^gh\s+release\s+(?:view|list|download)(?:\s|$)/i,
      /^gh\s+run\s+(?:view|list|watch|download)(?:\s|$)/i,
      /^gh\s+workflow\s+(?:view|list)(?:\s|$)/i,
      /^gh\s+(?:search|status|api)(?:\s|$)/i,
      /^gh\s+auth\s+(?:status|token)(?:\s|$)/i,
      /^gh\s+config\s+(?:list|get)(?:\s|$)/i,
      /^gh\s+gist\s+(?:view|list)(?:\s|$)/i,
      /^gh\s+cache\s+list(?:\s|$)/i,
      /^gh\s+project\s+(?:view|list)(?:\s|$)/i,
      /^gh\s+org\s+list(?:\s|$)/i,
      /^gh\s+ruleset(?:\s|$)/i,
      /^gh\s+label\s+list(?:\s|$)/i,
      /^gh\s+secret\s+list(?:\s|$)/i,
      /^gh\s+variable\s+(?:list|get)(?:\s|$)/i,
      /^gh\s+(?:ssh-key|gpg-key)\s+list(?:\s|$)/i,
      /^gh\s+codespace\s+(?:list|view|logs|ports)(?:\s|$)/i,
      /^gh\s+extension\s+list(?:\s|$)/i,
      /^gh\s+alias\s+list(?:\s|$)/i,
      /^gh\s+attestation(?:\s|$)/i,
      /^gh\s+browse\s+(?:--no-browser|-n)(?:\s|$)/i,
      /^gh\s+(?:--help|help)(?:\s|$)/i
    ]
  },
  {
    name: "gt",
    allow: [
      /^gt\s+(?:log|ls|ll|l|info|children|parent|trunk|docs|guide|g|changelog|dash|pr|completion|--help|-h)(?:\s|$)/i
    ]
  }
];

const COMMAND_SHORTCUTS = [
  { key: "ctrl+alt+s", command: "/settings", description: "Open settings" },
  { key: "ctrl+alt+c", command: "/compact", description: "Compact current session" },
  { key: "ctrl+alt+x", command: "/export", description: "Export current session" },
  { key: "ctrl+alt+y", command: "/copy", description: "Copy last assistant message" }
] as const;

function splitCommand(command: string): string[] {
  return command
    .split(/(?:&&|\|\||;|\n)/)
    .map((segment) => segment.trim())
    .filter((segment) => segment.length > 0);
}

function getBlockedReason(segment: string): string | undefined {
  for (const pattern of DIRECTLY_BLOCKED) {
    if (pattern.test(segment)) return `Blocked command: ${segment}`;
  }

  for (const group of READONLY_GROUPS) {
    if (!segment.toLowerCase().startsWith(`${group.name} `) && segment.toLowerCase() !== group.name) {
      continue;
    }
    if (group.allow.some((pattern) => pattern.test(segment))) return undefined;
    return `Blocked non-read-only ${group.name} command: ${segment}`;
  }

  return undefined;
}

function findBlockedReason(command: string): string | undefined {
  for (const segment of splitCommand(command)) {
    const reason = getBlockedReason(segment);
    if (reason) return reason;
  }
  return undefined;
}

async function runBuiltInCommand(pi: ExtensionAPI, ctx: ExtensionContext, command: string): Promise<void> {
  if (!ctx.isIdle()) {
    ctx.ui.notify(`Wait until pi is idle: ${command}`, "warning");
    return;
  }
  pi.sendUserMessage(command);
}

export default function (pi: ExtensionAPI) {
  pi.registerShortcut("ctrl+p", {
    description: "Open slash command palette",
    handler: async (ctx) => {
      if (!ctx.isIdle()) {
        ctx.ui.notify("Command palette only available while idle", "warning");
        return;
      }
      ctx.ui.setEditorText("/");
    }
  });

  for (const shortcut of COMMAND_SHORTCUTS) {
    pi.registerShortcut(shortcut.key, {
      description: shortcut.description,
      handler: async (ctx) => {
        await runBuiltInCommand(pi, ctx, shortcut.command);
      }
    });
  }

  pi.on("tool_call", async (event, ctx) => {
    if (!isToolCallEventType("bash", event)) return undefined;

    const reason = findBlockedReason(event.input.command);
    if (!reason) return undefined;

    ctx.ui.notify(reason, "warning");
    return { block: true, reason };
  });

  pi.on("user_bash", async (event, ctx) => {
    const reason = findBlockedReason(event.command);
    if (!reason) return undefined;

    ctx.ui.notify(reason, "warning");
    return {
      result: {
        output: `${reason}\n`,
        exitCode: 1,
        cancelled: false,
        truncated: false
      }
    };
  });
}
