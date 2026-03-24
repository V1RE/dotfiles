import { basename } from "node:path";

import type { PermissionRequest, Session } from "@opencode-ai/sdk";
import type { Plugin } from "@opencode-ai/plugin";

type SessionPhase = "running" | "ready" | "needs-input" | "error";

interface SessionState {
  info?: Session;
  phase?: SessionPhase;
}

interface NotificationInput {
  title: string;
  subtitle?: string;
  body?: string;
}

const STATUS_KEY = "opencode";
const CMUX_COMMAND_TIMEOUT_MS = 1_000;

function inCmux(): boolean {
  return Boolean(
    process.env.CMUX_SURFACE_ID || process.env.CMUX_WORKSPACE_ID || process.env.CMUX_SOCKET_PATH,
  );
}

function getCmuxBinary(): string | undefined {
  return Bun.which("cmux");
}

function sessionLabel(session?: Session): string {
  const title = session?.title.trim();
  if (title) {
    return title;
  }

  const directory = session?.directory.trim();
  if (directory) {
    return basename(directory);
  }

  return "Session";
}

function truncate(value: string, maxLength: number): string {
  if (value.length <= maxLength) {
    return value;
  }

  return `${value.slice(0, maxLength - 1)}…`;
}

function formatPermissionRequest(request: PermissionRequest): string {
  const patterns = request.patterns.filter((pattern) => pattern.trim().length > 0);
  const permission = request.permission.trim();
  const permissionLabel = permission.length > 0 ? permission : "Tool";

  if (patterns.length === 0) {
    return `${permissionLabel} permission requested`;
  }

  const preview = patterns
    .slice(0, 2)
    .map((pattern) => truncate(pattern, 80))
    .join(" • ");
  const suffix = patterns.length > 2 ? ` (+${patterns.length - 2} more)` : "";
  return `${permissionLabel}: ${preview}${suffix}`;
}

function ensureSessionState(states: Map<string, SessionState>, sessionID: string): SessionState {
  const existing = states.get(sessionID);
  if (existing) {
    return existing;
  }

  const created: SessionState = {};
  states.set(sessionID, created);
  return created;
}

async function runCmuxCommand(args: string[]): Promise<boolean> {
  if (!inCmux()) {
    return false;
  }

  const cmux = getCmuxBinary();
  if (!cmux) {
    return false;
  }

  const socketPath = process.env.CMUX_SOCKET_PATH;
  const command = socketPath ? [cmux, "--socket", socketPath, ...args] : [cmux, ...args];
  const proc = Bun.spawn(command, {
    stdout: "ignore",
    stderr: "ignore",
  });

  const timeout = setTimeout(() => {
    proc.kill();
  }, CMUX_COMMAND_TIMEOUT_MS);

  try {
    const exitCode = await proc.exited;
    return exitCode === 0;
  } finally {
    clearTimeout(timeout);
  }
}

async function setStatus(value: string): Promise<void> {
  await runCmuxCommand(["set-status", STATUS_KEY, value]);
}

async function clearStatus(): Promise<void> {
  await runCmuxCommand(["clear-status", STATUS_KEY]);
}

async function notify(input: NotificationInput): Promise<void> {
  const args = ["notify", "--title", input.title];

  if (input.subtitle) {
    args.push("--subtitle", input.subtitle);
  }

  if (input.body) {
    args.push("--body", input.body);
  }

  await runCmuxCommand(args);
}

async function transitionPhase(
  states: Map<string, SessionState>,
  sessionID: string,
  phase: SessionPhase,
): Promise<boolean> {
  const state = ensureSessionState(states, sessionID);
  if (state.phase === phase) {
    return false;
  }

  state.phase = phase;

  switch (phase) {
    case "running":
      await setStatus("Running");
      break;
    case "ready":
      await setStatus("Ready");
      break;
    case "needs-input":
      await setStatus("Needs input");
      break;
    case "error":
      await setStatus("Error");
      break;
  }

  return true;
}

export const CmuxPlugin: Plugin = async () => {
  const sessionStates = new Map<string, SessionState>();

  return {
    event: async ({ event }) => {
      if (!inCmux()) {
        return;
      }

      switch (event.type) {
        case "session.created": {
          const state = ensureSessionState(sessionStates, event.properties.info.id);
          state.info = event.properties.info;
          return;
        }

        case "session.updated": {
          const state = ensureSessionState(sessionStates, event.properties.info.id);
          state.info = event.properties.info;
          return;
        }

        case "session.deleted": {
          sessionStates.delete(event.properties.info.id);
          if (sessionStates.size === 0) {
            await clearStatus();
          }
          return;
        }

        case "session.status": {
          if (event.properties.status.type !== "busy") {
            return;
          }

          await transitionPhase(sessionStates, event.properties.sessionID, "running");
          return;
        }

        case "permission.asked": {
          const state = ensureSessionState(sessionStates, event.properties.sessionID);
          const changed = await transitionPhase(
            sessionStates,
            event.properties.sessionID,
            "needs-input",
          );

          await notify({
            title: "OpenCode needs input",
            subtitle: sessionLabel(state.info),
            body: formatPermissionRequest(event.properties),
          });

          if (!changed) {
            await setStatus("Needs input");
          }
          return;
        }

        case "permission.replied": {
          await transitionPhase(sessionStates, event.properties.sessionID, "running");
          return;
        }

        case "session.idle": {
          const state = ensureSessionState(sessionStates, event.properties.sessionID);
          const changed = await transitionPhase(sessionStates, event.properties.sessionID, "ready");
          if (changed) {
            await notify({
              title: "OpenCode response ready",
              subtitle: sessionLabel(state.info),
            });
          }
          return;
        }

        case "session.error": {
          const sessionID = event.properties.sessionID;
          if (!sessionID) {
            return;
          }

          const state = ensureSessionState(sessionStates, sessionID);
          await transitionPhase(sessionStates, sessionID, "error");
          await notify({
            title: "OpenCode error",
            subtitle: sessionLabel(state.info),
          });
          return;
        }

        default:
          return;
      }
    },
  };
};
