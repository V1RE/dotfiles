import { test } from "bun:test";
import assert from "node:assert/strict";
import {
  mkdtemp,
  readFile,
  readdir,
  rm,
  stat,
  writeFile,
} from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import {
  ensureNamingPromptFile,
  ensureProviderFile,
} from "../src/configure.ts";
import {
  PiNamer,
  loadProviderConfig,
  type CompletionRequest,
  type PiSession,
} from "../src/provider.ts";
import { type NamingContext } from "../src/domain.ts";

const context: NamingContext = {
  project: "Agents",
  userRequests: ["Fix socket reconnect"],
};

interface FakeSession extends PiSession {
  prompts: string[];
  aborted: boolean;
  disposed: boolean;
}

/** Session that answers immediately, like a completed model request. */
function replyingSession(text: string, errorMessage?: string): FakeSession {
  const session: FakeSession = {
    prompts: [],
    aborted: false,
    disposed: false,
    state: { errorMessage },
    async prompt(input) {
      session.prompts.push(input);
    },
    async abort() {
      session.aborted = true;
    },
    dispose() {
      session.disposed = true;
    },
    getLastAssistantText() {
      return text;
    },
  };
  return session;
}

/** Session whose request only settles once the caller aborts it. */
function hangingSession(): FakeSession {
  let release = (): void => {};
  const session: FakeSession = {
    prompts: [],
    aborted: false,
    disposed: false,
    state: {},
    prompt(input) {
      session.prompts.push(input);
      return new Promise<void>((resolve) => {
        release = resolve;
      });
    },
    async abort() {
      session.aborted = true;
      release();
    },
    dispose() {
      session.disposed = true;
    },
    getLastAssistantText() {
      return undefined;
    },
  };
  return session;
}

async function tempConfig() {
  const root = await mkdtemp(path.join(os.tmpdir(), "smart-rename-pi-provider-"));
  return {
    root,
    file: path.join(root, "provider.env"),
    env: { HERDR_PLUGIN_CONFIG_DIR: root },
  };
}

test("provider config preserves defaults and process-over-file precedence", async () => {
  const fixture = await tempConfig();
  try {
    const defaults = await loadProviderConfig({
      ...fixture.env,
      OPENAI_API_KEY: "standalone-key",
    });
    assert.deepEqual(defaults, {
      timeoutMs: 45_000,
      reasoningEffort: "medium",
      apiKey: "standalone-key",
    });
    await assert.rejects(loadProviderConfig(fixture.env), /AI key missing/);

    await writeFile(
      fixture.file,
      [
        "SMART_RENAME_TIMEOUT_MS=20000",
        "SMART_RENAME_REASONING_EFFORT=low",
        "SMART_RENAME_PROMPT_PATH=prompts/custom.md",
        "OPENAI_API_KEY=file-key",
      ].join("\n"),
    );
    assert.deepEqual(await loadProviderConfig(fixture.env), {
      timeoutMs: 20_000,
      reasoningEffort: "low",
      promptPath: path.join(fixture.root, "prompts/custom.md"),
      apiKey: "file-key",
    });

    const config = await loadProviderConfig({
      ...fixture.env,
      SMART_RENAME_TIMEOUT_MS: "30000",
      SMART_RENAME_REASONING_EFFORT: "high",
      SMART_RENAME_API_KEY: "process-key",
    });
    assert.deepEqual(config, {
      timeoutMs: 30_000,
      reasoningEffort: "high",
      promptPath: path.join(fixture.root, "prompts/custom.md"),
      apiKey: "process-key",
    });

    await writeFile(
      fixture.file,
      "SMART_RENAME_API_KEY=file-alias-key\nOPENAI_API_KEY=file-openai-key\n",
    );
    assert.equal(
      (
        await loadProviderConfig({
          ...fixture.env,
          OPENAI_API_KEY: "process-openai-key",
        })
      ).apiKey,
      "process-openai-key",
    );
    assert.equal((await loadProviderConfig(fixture.env)).apiKey, "file-alias-key");
    await assert.rejects(
      loadProviderConfig({ ...fixture.env, SMART_RENAME_TIMEOUT_MS: "10" }),
      /SMART_RENAME_TIMEOUT_MS must be 1000-300000/,
    );
  } finally {
    await rm(fixture.root, { recursive: true, force: true });
  }
});

test("private provider and prompt config enforce templates, permissions, and bounds", async () => {
  const fixture = await tempConfig();
  await rm(fixture.root, { recursive: true, force: true });
  try {
    const file = await ensureProviderFile(fixture.env);
    const prompt = await ensureNamingPromptFile(fixture.env);
    assert.equal((await stat(fixture.root)).mode & 0o777, 0o700);
    assert.equal((await stat(file)).mode & 0o777, 0o600);
    assert.equal((await stat(prompt)).mode & 0o777, 0o600);
    assert.match(await readFile(file, "utf8"), /^OPENAI_API_KEY=$/m);
    assert.match(await readFile(prompt, "utf8"), /^# Naming policy/);
    await assert.rejects(loadProviderConfig(fixture.env), /AI key missing.*provider\.env/i);
    await writeFile(file, "x".repeat(16 * 1024 + 1));
    await assert.rejects(loadProviderConfig(fixture.env), /exceeds 16 KiB/);
  } finally {
    await rm(fixture.root, { recursive: true, force: true });
  }
});

test("namer runs one isolated session per request and validates model output", async () => {
  const requests: CompletionRequest[] = [];
  const sessions: FakeSession[] = [];
  const namer = new PiNamer(
    { SMART_RENAME_API_KEY: "standalone-key" },
    async (request) => {
      requests.push(request);
      const session = replyingSession(
        '```json\n{"tab":"Repair Socket Reconnect","reason":"current task"}\n```',
      );
      sessions.push(session);
      return session;
    },
  );
  assert.deepEqual(await namer.suggest(context), {
    tab: "Repair Socket Reconnect",
    reason: "current task",
  });
  await namer.suggest(context);
  assert.equal(sessions.length, 2);
  assert.equal(requests.length, 2);
  assert.equal(requests[0]?.config.reasoningEffort, "medium");
  assert.equal(requests[0]?.config.timeoutMs, 45_000);
  assert.match(requests[0]?.system || "", /^# Naming policy/);
  assert.match(requests[0]?.system || "", /return exactly one JSON object/i);
  assert.match(sessions[0]?.prompts[0] || "", /Fix socket reconnect/);
  assert.equal(sessions[0]?.prompts.length, 1);
  assert.equal(sessions[0]?.disposed, true);

  const abstain = new PiNamer(
    { SMART_RENAME_API_KEY: "standalone-key" },
    async () => replyingSession('{"tab":null,"reason":"no meaningful task"}'),
  );
  assert.deepEqual(await abstain.suggest(context), {
    tab: null,
    reason: "no meaningful task",
  });
  const invalid = new PiNamer(
    { SMART_RENAME_API_KEY: "standalone-key" },
    async () => replyingSession('{"tab":"bad","reason":"bad"}'),
  );
  await assert.rejects(invalid.suggest(context), /invalid model tab label/);
});

test("namer surfaces model failures and always disposes the session", async () => {
  const failed = replyingSession("", "402 insufficient quota");
  const failing = new PiNamer(
    { SMART_RENAME_API_KEY: "standalone-key" },
    async () => failed,
  );
  await assert.rejects(failing.suggest(context), /insufficient quota/);
  assert.equal(failed.disposed, true);

  const silent = replyingSession("");
  const empty = new PiNamer(
    { SMART_RENAME_API_KEY: "standalone-key" },
    async () => silent,
  );
  await assert.rejects(empty.suggest(context), /model returned no text/);
  assert.equal(silent.disposed, true);
});

test("timeout aborts the running request, waits for it, and disposes", async () => {
  const hanging = hangingSession();
  const namer = new PiNamer(
    { SMART_RENAME_API_KEY: "standalone-key", SMART_RENAME_TIMEOUT_MS: "1000" },
    async () => hanging,
  );
  await assert.rejects(namer.suggest(context), /timed out/);
  assert.equal(hanging.aborted, true);
  assert.equal(hanging.disposed, true);
});

test("namer reloads provider.env and naming-prompt.md, then redacts failures", async () => {
  const fixture = await tempConfig();
  const promptFile = path.join(fixture.root, "naming-prompt.md");
  const efforts: Array<string | undefined> = [];
  const systems: string[] = [];
  try {
    await writeFile(
      fixture.file,
      "OPENAI_API_KEY=first-key\nSMART_RENAME_REASONING_EFFORT=low\n",
    );
    await writeFile(promptFile, "First naming prompt");
    const namer = new PiNamer(fixture.env, async (request) => {
      efforts.push(request.config.reasoningEffort);
      systems.push(request.system);
      return replyingSession('{"tab":"First Task Name","reason":"task"}');
    });
    await namer.suggest(context);
    await writeFile(
      fixture.file,
      "OPENAI_API_KEY=second-key\nSMART_RENAME_REASONING_EFFORT=high\n",
    );
    await writeFile(promptFile, "Second naming prompt");
    await namer.suggest(context);
    assert.deepEqual(efforts, ["low", "high"]);
    assert.deepEqual(systems, ["First naming prompt", "Second naming prompt"]);

    const key = "standalone-secret-value";
    const failing = new PiNamer({ SMART_RENAME_API_KEY: key }, async () => {
      throw new Error(`401 Authorization: Bearer ${key}`);
    });
    await assert.rejects(failing.suggest(context), (error: unknown) => {
      assert.ok(error instanceof Error);
      assert.match(error.message, /AI request failed \(openai\/gpt-5\.6-luna\)/);
      assert.doesNotMatch(error.message, new RegExp(key));
      assert.match(error.message, /redacted/);
      return true;
    });
  } finally {
    await rm(fixture.root, { recursive: true, force: true });
  }
});

test("manifest starts the worker automatically and the namer stays on the Pi SDK", async () => {
  const manifest = await readFile(
    new URL("../herdr-plugin.toml", import.meta.url),
    "utf8",
  );
  assert.match(manifest, /^id = "tab-smart-rename-pi"$/m);
  assert.match(manifest, /^version = "0\.2\.0"$/m);
  assert.match(
    manifest,
    /command = \["bun", "install", "--production", "--frozen-lockfile"\]/,
  );
  assert.match(
    manifest,
    /\[\[startup\]\]\ncommand = \["sh", "src\/run-bun\.sh", "src\/cli\.ts", "start"\]/,
  );
  assert.match(
    manifest,
    /command = \["sh", "src\/run-bun\.sh", "src\/cli\.ts", "start"\]/,
  );
  assert.doesNotMatch(manifest, /command = \["bun", "src\//);
  assert.match(manifest, /id = "provider-config"[\s\S]*placement = "overlay"/);
  assert.match(manifest, /id = "prompt-config"[\s\S]*placement = "overlay"/);

  const src = new URL("../src/", import.meta.url);
  const source = (
    await Promise.all(
      (await readdir(src))
        .filter((file) => file.endsWith(".ts"))
        .map((file) => readFile(new URL(file, src), "utf8")),
    )
  ).join("\n");
  for (const required of [
    '@earendil-works/pi-coding-agent"',
    'noTools: "all"',
    "SessionManager.inMemory()",
    "SettingsManager.inMemory(",
    "noContextFiles: true",
  ]) {
    assert.ok(source.includes(required), required);
  }
  for (const forbidden of [
    "@ai-sdk/",
    "generateText",
    'spawn("pi")',
    '"--mode", "rpc"',
    "kimi-coding/",
  ]) {
    assert.equal(source.includes(forbidden), false, forbidden);
  }
});
