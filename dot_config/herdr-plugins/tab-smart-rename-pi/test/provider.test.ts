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
  checkModel,
  loadProviderConfig,
  type SessionRequest,
  type PiSession,
} from "../src/provider.ts";
import { type NamingContext } from "../src/domain.ts";

const context: NamingContext = {
  project: "Agents",
  userRequests: ["Fix socket reconnect"],
};

/** Model Pi resolves from its own settings in these tests. */
const MODEL = { provider: "anthropic", id: "claude-smoke" };

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
    state: { errorMessage, model: MODEL },
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
    state: { model: MODEL },
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

test("provider config keeps defaults and process-over-file precedence", async () => {
  const fixture = await tempConfig();
  try {
    assert.deepEqual(await loadProviderConfig(fixture.env), { timeoutMs: 45_000 });

    await writeFile(
      fixture.file,
      [
        "SMART_RENAME_TIMEOUT_MS=20000",
        "SMART_RENAME_PROMPT_PATH=prompts/custom.md",
      ].join("\n"),
    );
    assert.deepEqual(await loadProviderConfig(fixture.env), {
      timeoutMs: 20_000,
      promptPath: path.join(fixture.root, "prompts/custom.md"),
    });

    assert.deepEqual(
      await loadProviderConfig({
        ...fixture.env,
        SMART_RENAME_TIMEOUT_MS: "30000",
        SMART_RENAME_PROMPT_PATH: "/abs/prompt.md",
      }),
      { timeoutMs: 30_000, promptPath: "/abs/prompt.md" },
    );

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
    const template = await readFile(file, "utf8");
    assert.match(template, /^SMART_RENAME_TIMEOUT_MS=45000$/m);
    assert.doesNotMatch(template, /API_KEY/);
    assert.match(await readFile(prompt, "utf8"), /^# Naming policy/);
    assert.deepEqual(await loadProviderConfig(fixture.env), { timeoutMs: 45_000 });
    await writeFile(file, "x".repeat(16 * 1024 + 1));
    await assert.rejects(loadProviderConfig(fixture.env), /exceeds 16 KiB/);
  } finally {
    await rm(fixture.root, { recursive: true, force: true });
  }
});

test("namer runs one isolated session per request and validates model output", async () => {
  const requests: SessionRequest[] = [];
  const sessions: FakeSession[] = [];
  const namer = new PiNamer({}, async (request) => {
    requests.push(request);
    const session = replyingSession(
      '```json\n{"tab":"Repair Socket Reconnect","reason":"current task"}\n```',
    );
    sessions.push(session);
    return session;
  });
  assert.deepEqual(await namer.suggest(context), {
    tab: "Repair Socket Reconnect",
    reason: "current task",
  });
  await namer.suggest(context);
  assert.equal(sessions.length, 2);
  assert.equal(requests.length, 2);
  assert.deepEqual(requests[0]?.config, { timeoutMs: 45_000 });
  assert.match(requests[0]?.system || "", /^# Naming policy/);
  assert.match(requests[0]?.system || "", /return exactly one JSON object/i);
  assert.match(sessions[0]?.prompts[0] || "", /Fix socket reconnect/);
  assert.equal(sessions[0]?.prompts.length, 1);
  assert.equal(sessions[0]?.disposed, true);

  const abstain = new PiNamer({}, async () =>
    replyingSession('{"tab":null,"reason":"no meaningful task"}'),
  );
  assert.deepEqual(await abstain.suggest(context), {
    tab: null,
    reason: "no meaningful task",
  });
  const invalid = new PiNamer({}, async () =>
    replyingSession('{"tab":"bad","reason":"bad"}'),
  );
  await assert.rejects(invalid.suggest(context), /invalid model tab label/);
});

test("namer surfaces model failures and always disposes the session", async () => {
  const failed = replyingSession("", "402 insufficient quota");
  const failing = new PiNamer({}, async () => failed);
  await assert.rejects(failing.suggest(context), /insufficient quota/);
  assert.equal(failed.disposed, true);

  const silent = replyingSession("");
  const empty = new PiNamer({}, async () => silent);
  await assert.rejects(empty.suggest(context), /model returned no text/);
  assert.equal(silent.disposed, true);
});

test("timeout aborts the running request, waits for it, and disposes", async () => {
  const hanging = hangingSession();
  const namer = new PiNamer({ SMART_RENAME_TIMEOUT_MS: "1000" }, async () => hanging);
  await assert.rejects(namer.suggest(context), /timed out/);
  assert.equal(hanging.aborted, true);
  assert.equal(hanging.disposed, true);
});

test("namer reloads the prompt, labels errors with Pi's model, and hides credentials", async () => {
  const fixture = await tempConfig();
  const promptFile = path.join(fixture.root, "naming-prompt.md");
  const systems: string[] = [];
  try {
    await writeFile(promptFile, "First naming prompt");
    const namer = new PiNamer(fixture.env, async (request) => {
      systems.push(request.system);
      return replyingSession('{"tab":"First Task Name","reason":"task"}');
    });
    await namer.suggest(context);
    await writeFile(promptFile, "Second naming prompt");
    await namer.suggest(context);
    assert.deepEqual(systems, ["First naming prompt", "Second naming prompt"]);
  } finally {
    await rm(fixture.root, { recursive: true, force: true });
  }

  const labelled = new PiNamer({}, async () =>
    replyingSession("", "429 rate limited"),
  );
  await assert.rejects(
    labelled.suggest(context),
    /AI request failed \(anthropic\/claude-smoke\): 429 rate limited/,
  );

  // Provider errors can echo the credential Pi loaded from ~/.pi/agent/auth.json.
  const secrets = [
    "sk-live-AbCdEf0123456789abcdef",
    "Bearer sk-ant-api03-QWERTYUIOP1234567890",
    "OPENAI_API_KEY=hunter2-super-secret-value",
  ];
  for (const secret of secrets) {
    const leaking = new PiNamer({}, async () =>
      replyingSession("", `401 unauthorized: ${secret}`),
    );
    await assert.rejects(leaking.suggest(context), (error: unknown) => {
      assert.ok(error instanceof Error);
      assert.match(error.message, /401 unauthorized/);
      assert.match(error.message, /\[redacted\]/);
      assert.doesNotMatch(error.message, /AbCdEf0123456789abcdef|QWERTYUIOP1234567890|hunter2/);
      return true;
    });
  }
});

test("checkModel reports the resolved model and disposes the session", async () => {
  const sessions: FakeSession[] = [];
  const label = await checkModel({}, async () => {
    const session = replyingSession("");
    sessions.push(session);
    return session;
  });
  assert.equal(label, "anthropic/claude-smoke");
  assert.equal(sessions[0]?.prompts.length, 0);
  assert.equal(sessions[0]?.disposed, true);
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
    "SettingsManager.create(cwd, agentDir)",
    "agentDir = getAgentDir()",
    "noContextFiles: true",
  ]) {
    assert.ok(source.includes(required), required);
  }
  // Pi resolves credentials and the model; the plugin must not take that over.
  for (const forbidden of [
    "@ai-sdk/",
    "generateText",
    'spawn("pi")',
    '"--mode", "rpc"',
    "setRuntimeApiKey",
    "ModelRuntime",
    "apiKey",
    "API_KEY",
    "SMART_RENAME_MODEL",
  ]) {
    assert.equal(source.includes(forbidden), false, forbidden);
  }
});
