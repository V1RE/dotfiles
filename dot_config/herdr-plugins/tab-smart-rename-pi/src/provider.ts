import { mkdir } from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { fileURLToPath } from "node:url";
import {
  createAgentSession,
  DefaultResourceLoader,
  ModelRuntime,
  SessionManager,
  SettingsManager,
} from "@earendil-works/pi-coding-agent";
import { parse as parseEnv } from "dotenv";
import { z } from "zod";
import {
  type NameSuggestion,
  type NamingContext,
  validateTabLabel,
} from "./domain.ts";
import { sanitizeText } from "./text.ts";

const PROVIDER_ENV_BYTES = 16 * 1024;
const NAMING_PROMPT_BYTES = 32 * 1024;
const PROVIDER_EXAMPLE_URL = new URL("../provider.env.example", import.meta.url);
const BUNDLED_NAMING_PROMPT = fileURLToPath(
  new URL("../docs/naming-policy.md", import.meta.url),
);
export const PROVIDER_ENV_NAME = "provider.env";
export const NAMING_PROMPT_NAME = "naming-prompt.md";

/** Pi Coding Agent provider and model. Both are fixed for this plugin. */
export const PI_PROVIDER = "openai";
export const PI_MODEL = "gpt-5.6-luna";

/**
 * Private directory for the isolated Pi runtime.
 *
 * Pi never reads the user's ~/.pi/agent from here: no extensions, skills,
 * prompts, themes, context files, sessions, settings, or stored credentials.
 */
const ISOLATED_AGENT_DIR = path.join(os.tmpdir(), "tab-smart-rename-pi-agent");

const ProviderConfigSchema = z.object({
  timeoutMs: z.number().int().min(1_000).max(300_000),
  reasoningEffort: z.enum(["low", "medium", "high"]).optional(),
  promptPath: z.string().min(1).optional(),
  apiKey: z.string().min(1),
});

const ModelOutputSchema = z.object({
  tab: z.string().nullable(),
  reason: z.string(),
});

export type ProviderConfig = z.infer<typeof ProviderConfigSchema>;

export interface Namer {
  suggest(context: NamingContext): Promise<NameSuggestion>;
}

export function providerEnvPath(env: NodeJS.ProcessEnv = process.env): string | null {
  return env.HERDR_PLUGIN_CONFIG_DIR
    ? path.join(env.HERDR_PLUGIN_CONFIG_DIR, PROVIDER_ENV_NAME)
    : null;
}

async function readBoundedText(
  source: string | URL,
  label: string,
  maxBytes: number,
  required = false,
): Promise<string | null> {
  const file = Bun.file(source);
  if (!(await file.exists())) {
    if (required) throw new Error(`${label} is missing`);
    return null;
  }
  if (file.size > maxBytes) {
    throw new Error(`${label} exceeds ${maxBytes / 1024} KiB`);
  }
  return file.text();
}

async function readProviderEnv(
  filePath: string | URL | null,
  required = false,
): Promise<Record<string, string>> {
  if (!filePath) return {};
  const text = await readBoundedText(
    filePath,
    filePath === PROVIDER_EXAMPLE_URL ? "provider.env.example" : PROVIDER_ENV_NAME,
    PROVIDER_ENV_BYTES,
    required,
  );
  return text === null ? {} : parseEnv(text);
}

export async function providerExampleText(): Promise<string> {
  return (
    (await readBoundedText(
      PROVIDER_EXAMPLE_URL,
      "provider.env.example",
      PROVIDER_ENV_BYTES,
      true,
    )) || ""
  );
}

export async function bundledNamingPrompt(): Promise<string> {
  return readNamingPrompt(BUNDLED_NAMING_PROMPT, true);
}

function pick(
  processEnv: NodeJS.ProcessEnv,
  fileEnv: Record<string, string>,
  defaults: Record<string, string>,
  name: string,
): string {
  return processEnv[name] || fileEnv[name] || defaults[name] || "";
}

function resolvePromptPath(value: string, env: NodeJS.ProcessEnv): string {
  if (path.isAbsolute(value)) return value;
  return path.resolve(env.HERDR_PLUGIN_CONFIG_DIR || process.cwd(), value);
}

export async function configuredNamingPromptPath(
  env: NodeJS.ProcessEnv = process.env,
): Promise<string> {
  const fileEnv = await readProviderEnv(providerEnvPath(env));
  const configured = env.SMART_RENAME_PROMPT_PATH || fileEnv.SMART_RENAME_PROMPT_PATH;
  if (configured) return resolvePromptPath(configured, env);
  return env.HERDR_PLUGIN_CONFIG_DIR
    ? path.join(env.HERDR_PLUGIN_CONFIG_DIR, NAMING_PROMPT_NAME)
    : BUNDLED_NAMING_PROMPT;
}

async function readNamingPrompt(filePath: string, required = false): Promise<string> {
  const text = await readBoundedText(
    filePath,
    path.basename(filePath),
    NAMING_PROMPT_BYTES,
    required,
  );
  const prompt = text?.trim();
  if (!prompt) throw new Error(`${path.basename(filePath)} is empty`);
  return prompt;
}

function configError(error: z.ZodError): Error {
  const field = error.issues[0]?.path[0];
  const messages: Record<PropertyKey, string> = {
    timeoutMs: "SMART_RENAME_TIMEOUT_MS must be 1000-300000",
    reasoningEffort: "SMART_RENAME_REASONING_EFFORT must be low, medium, or high",
    promptPath: "SMART_RENAME_PROMPT_PATH is invalid",
    apiKey: `AI key missing. Run configure-ai or set OPENAI_API_KEY in ${PROVIDER_ENV_NAME}`,
  };
  return new Error(messages[field ?? ""] ?? "AI provider configuration is invalid");
}

export async function loadProviderConfig(
  env: NodeJS.ProcessEnv = process.env,
): Promise<ProviderConfig> {
  const [defaults, fileEnv] = await Promise.all([
    readProviderEnv(PROVIDER_EXAMPLE_URL, true),
    readProviderEnv(providerEnvPath(env)),
  ]);
  const reasoningEffort = pick(env, fileEnv, defaults, "SMART_RENAME_REASONING_EFFORT");
  const configuredPrompt =
    env.SMART_RENAME_PROMPT_PATH || fileEnv.SMART_RENAME_PROMPT_PATH;
  const input = {
    timeoutMs: Number(pick(env, fileEnv, defaults, "SMART_RENAME_TIMEOUT_MS")),
    ...(reasoningEffort ? { reasoningEffort } : {}),
    ...(configuredPrompt
      ? { promptPath: resolvePromptPath(configuredPrompt, env) }
      : {}),
    // Process environment wins over provider.env for every key alias.
    apiKey:
      env.SMART_RENAME_API_KEY ||
      env.OPENAI_API_KEY ||
      fileEnv.SMART_RENAME_API_KEY ||
      fileEnv.OPENAI_API_KEY ||
      "",
  };
  const parsed = ProviderConfigSchema.safeParse(input);
  if (!parsed.success) throw configError(parsed.error);
  return parsed.data;
}

export async function loadNamingPrompt(
  config: ProviderConfig,
  env: NodeJS.ProcessEnv = process.env,
): Promise<string> {
  if (config.promptPath) return readNamingPrompt(config.promptPath, true);

  if (env.HERDR_PLUGIN_CONFIG_DIR) {
    const privatePrompt = path.join(env.HERDR_PLUGIN_CONFIG_DIR, NAMING_PROMPT_NAME);
    const text = await readBoundedText(
      privatePrompt,
      NAMING_PROMPT_NAME,
      NAMING_PROMPT_BYTES,
    );
    if (text !== null) {
      const prompt = text.trim();
      if (!prompt) throw new Error(`${NAMING_PROMPT_NAME} is empty`);
      return prompt;
    }
  }

  return bundledNamingPrompt();
}

function parseSuggestion(text: string): NameSuggestion {
  const cleaned = text
    .replace(/^```(?:json)?\s*/i, "")
    .replace(/\s*```$/i, "")
    .trim();
  const output = ModelOutputSchema.parse(JSON.parse(cleaned));
  if (output.tab === null) {
    return { tab: null, reason: sanitizeText(output.reason) };
  }
  if (!validateTabLabel(output.tab)) {
    throw new Error(`invalid model tab label: ${JSON.stringify(output.tab)}`);
  }
  return { tab: sanitizeText(output.tab), reason: sanitizeText(output.reason) };
}

function safeProviderError(error: unknown, config: ProviderConfig): string {
  let message = error instanceof Error ? error.message : String(error || "provider request failed");
  message = message.replaceAll(config.apiKey, "[redacted]");
  return sanitizeText(message).slice(0, 400) || "provider request failed";
}

export interface CompletionRequest {
  config: ProviderConfig;
  context: NamingContext;
  system: string;
}

/**
 * The part of Pi's AgentSession this plugin uses.
 *
 * A narrow port keeps the timeout, abort, and disposal contract testable
 * without a live model request.
 */
export interface PiSession {
  prompt(text: string, options: { expandPromptTemplates: boolean }): Promise<void>;
  abort(): Promise<void>;
  dispose(): void;
  getLastAssistantText(): string | undefined;
  readonly state: { readonly errorMessage?: string | undefined };
}

export type CreateSession = (request: CompletionRequest) => Promise<PiSession>;

async function createPiSession(request: CompletionRequest): Promise<PiSession> {
  await mkdir(ISOLATED_AGENT_DIR, { recursive: true, mode: 0o700 });
  const agentDir = ISOLATED_AGENT_DIR;
  const modelRuntime = await ModelRuntime.create({
    authPath: path.join(agentDir, "auth.json"),
    modelsPath: null,
  });
  // Runtime keys stay in memory; nothing writes the user's key to disk.
  await modelRuntime.setRuntimeApiKey(PI_PROVIDER, request.config.apiKey);
  const model = modelRuntime.getModel(PI_PROVIDER, PI_MODEL);
  if (!model) throw new Error(`${PI_PROVIDER}/${PI_MODEL} is unknown to Pi`);

  const settingsManager = SettingsManager.inMemory({
    compaction: { enabled: false },
    retry: { enabled: false },
  });
  const resourceLoader = new DefaultResourceLoader({
    cwd: agentDir,
    agentDir,
    settingsManager,
    noExtensions: true,
    noSkills: true,
    noPromptTemplates: true,
    noThemes: true,
    noContextFiles: true,
    systemPromptOverride: () => request.system,
    appendSystemPromptOverride: () => [],
  });
  await resourceLoader.reload();

  const { session } = await createAgentSession({
    cwd: agentDir,
    agentDir,
    modelRuntime,
    model,
    ...(request.config.reasoningEffort
      ? { thinkingLevel: request.config.reasoningEffort }
      : {}),
    noTools: "all",
    resourceLoader,
    sessionManager: SessionManager.inMemory(),
    settingsManager,
  });
  return session;
}

/**
 * Run one prompt with a hard timeout.
 *
 * `prompt()` takes no AbortSignal, so a timeout aborts the session, waits for
 * the request to settle, and always disposes it.
 */
export async function completeWithSession(
  session: PiSession,
  request: CompletionRequest,
): Promise<string> {
  const deadline = AbortSignal.timeout(request.config.timeoutMs);
  const settled = session
    .prompt(
      `Suggest one label from this sanitized context:\n${JSON.stringify(request.context)}`,
      { expandPromptTemplates: false },
    )
    .then(() => "settled" as const);
  const timeout = new Promise<"timeout">((resolve) => {
    deadline.addEventListener("abort", () => resolve("timeout"), { once: true });
  });
  try {
    if ((await Promise.race([settled, timeout])) === "timeout") {
      await session.abort();
      await settled.catch(() => {});
      throw new Error("request timed out");
    }
    const failure = session.state.errorMessage;
    if (failure) throw new Error(failure);
    const text = session.getLastAssistantText();
    if (!text) throw new Error("model returned no text");
    return text;
  } finally {
    await settled.catch(() => {});
    session.dispose();
  }
}

export class PiNamer implements Namer {
  readonly #env: NodeJS.ProcessEnv;
  readonly #createSession: CreateSession;

  constructor(
    env: NodeJS.ProcessEnv = process.env,
    createSession: CreateSession = createPiSession,
  ) {
    this.#env = env;
    this.#createSession = createSession;
  }

  async suggest(context: NamingContext): Promise<NameSuggestion> {
    const config = await loadProviderConfig(this.#env);
    const system = await loadNamingPrompt(config, this.#env);
    const request: CompletionRequest = { config, context, system };
    try {
      const session = await this.#createSession(request);
      return parseSuggestion(await completeWithSession(session, request));
    } catch (error) {
      throw new Error(
        `AI request failed (${PI_PROVIDER}/${PI_MODEL}): ${safeProviderError(error, config)}`,
      );
    }
  }
}
