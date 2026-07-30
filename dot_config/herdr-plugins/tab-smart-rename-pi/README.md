# herdr-tab-smart-rename-pi

**Tabs that say what the work is.** Named by Pi Coding Agent.

Smart Rename Pi turns numbered Herdr tabs into short task labels. Known
processes get instant names such as `Run Tests`, `Dev Server`, and `View Logs`.
Ambiguous work goes to OpenAI `gpt-5.6-luna` through the
[`@earendil-works/pi-coding-agent`](https://www.npmjs.com/package/@earendil-works/pi-coding-agent)
SDK. Manual names always win.

This plugin is a fork of [iurysza/herdr-tab-smart-rename](https://github.com/iurysza/herdr-tab-smart-rename).
Only the model transport changed: the Vercel AI SDK call became an isolated Pi
`AgentSession`.

## Install

Requires Herdr 0.7.0+ and Bun 1.1.34+. The source lives in chezmoi at
`dot_config/herdr-plugins/tab-smart-rename-pi`.

```sh
chezmoi apply ~/.config/herdr-plugins
cd ~/.config/herdr-plugins/tab-smart-rename-pi && bun install
herdr plugin link ~/.config/herdr-plugins/tab-smart-rename-pi
herdr plugin action invoke tab-smart-rename-pi.configure-ai
herdr plugin action invoke tab-smart-rename-pi.check-ai
herdr plugin action invoke tab-smart-rename-pi.start
```

`configure-ai` opens
`~/.config/herdr/plugins/config/tab-smart-rename-pi/provider.env`. Add:

```dotenv
OPENAI_API_KEY=...
```

Without a key, deterministic process names and workspace names still work; only
model-backed labels fail.

## Automatic start

A `[[startup]]` hook runs `start` after Herdr restores the session, so the
worker comes back on its own after a Herdr restart or live handoff. `start` is
idempotent: it exits early when the recorded worker process is still alive. Use
`stop` to turn the worker off for the rest of the session.

The worker subscribes to workspace, tab, and pane events, debounces tab
evaluation by 400 ms, sweeps every 60 seconds, and serializes its work.

## Keybindings

```toml
[[keys.command]]
key = "prefix+t"
type = "plugin_action"
command = "tab-smart-rename-pi.rename-now"
description = "smart rename current tab"

[[keys.command]]
key = "prefix+alt+t"
type = "plugin_action"
command = "tab-smart-rename-pi.rename-all"
description = "force smart rename all tabs"
```

Every explicit rename ends with a notification: renamed, not renamed, or
failed. During a model-backed current-tab rename, a diamond pulse appears
before its label.

## Actions

| Action | Effect |
| --- | --- |
| `rename-now` | Rename the current tab |
| `rename-all` | Rename every tab |
| `reset-tab` | Return the current tab to automatic naming |
| `reset-workspace` | Return the workspace to automatic naming |
| `configure-ai` | Edit provider settings |
| `configure-prompt` | Edit naming instructions |
| `check-ai` | Validate config without calling the model |
| `start` / `stop` / `status` | Control the worker |

```sh
herdr plugin action invoke tab-smart-rename-pi.<action>
```

## Naming behavior

Smart Rename uses one dominant pane: focused agent, another active agent,
focused command, then first pane. Supporting servers and logs never replace an
active agent's task.

Labels use 2–4 Title Case words, stay under 30 characters, and describe the
task—not its tool, model, or project. Weak evidence produces no rename. Manual
labels remain locked until reset or explicit rename.

See the [naming policy](docs/naming-policy.md) for the full contract.

## Configuration

The provider is always OpenAI and the model is always `gpt-5.6-luna`. Only these
settings remain, with defaults from
[`provider.env.example`](provider.env.example):

```dotenv
OPENAI_API_KEY=
SMART_RENAME_REASONING_EFFORT=medium
SMART_RENAME_TIMEOUT_MS=45000
```

`SMART_RENAME_API_KEY` is accepted as an alias for the OpenAI key. Process
environment wins over `provider.env`, which wins over the bundled defaults.
Config reloads before every model request.

### Custom prompt

The default system prompt is [`docs/naming-policy.md`](docs/naming-policy.md).
Create a private editable copy with:

```sh
herdr plugin action invoke tab-smart-rename-pi.configure-prompt
```

It opens
`~/.config/herdr/plugins/config/tab-smart-rename-pi/naming-prompt.md`. A prompt
can be this small:

```md
Name the current persistent task in 2–4 Title Case words.
Omit project, app, agent, and model names.
Return JSON only: {"tab":"Assess Python Migration","reason":"Current task."}
If unclear: {"tab":null,"reason":"no meaningful task"}
```

Set `SMART_RENAME_PROMPT_PATH` to use another file. Prompts reload per request;
built-in JSON and label validation still applies.

## Pi isolation

Each naming request builds one throwaway `AgentSession` and disposes it:

- `noTools: "all"` — the model cannot read files or run commands.
- `DefaultResourceLoader` with `noExtensions`, `noSkills`, `noPromptTemplates`,
  `noThemes`, and `noContextFiles` — no local Pi resources leak into the prompt.
- `systemPromptOverride` — the naming policy replaces Pi's coding-agent prompt.
- `SessionManager.inMemory()` and `SettingsManager.inMemory()` — no session
  files, no `~/.pi/agent/settings.json`.
- `ModelRuntime.create()` against a private, empty auth file plus
  `setRuntimeApiKey()` — your Pi credentials are never read and the key is never
  written to disk.
- `cwd` and `agentDir` point at a private directory under the temp dir, not at
  any project.

`prompt()` takes no `AbortSignal`, so `SMART_RENAME_TIMEOUT_MS` aborts the
session, waits for the request to settle, and disposes it.

## Privacy

Model requests contain bounded, sanitized evidence from the dominant pane. Pi
panes may contribute short user-request excerpts; sibling panes contribute
process summaries only. Smart Rename removes terminal formatting, common secret
shapes, and the local home path before sending context.

Provider keys stay in Herdr's private plugin config and never enter Smart Rename
state or logs. Model errors are redacted before they reach a notification.

## Troubleshooting

- Worker stopped: `herdr plugin action invoke tab-smart-rename-pi.start`
- Config invalid: run `configure-ai`, then `check-ai`.
- Authentication fails: check the OpenAI key; `check-ai` makes no API request.
- Bun is outside Herdr's server `PATH`: runtime actions also check standard Bun
  and Homebrew locations.
- Manual label stays: use `reset-tab` or an explicit rename.
- Logs: `herdr plugin log list --plugin tab-smart-rename-pi --limit 10`, plus
  `~/.local/state/herdr/plugins/tab-smart-rename-pi/worker.log`.

## Development

```sh
cd ~/.config/herdr-plugins/tab-smart-rename-pi
bun test
bun run check
```

Edit the chezmoi source, then `chezmoi apply ~/.config/herdr-plugins`. The link
points at the applied directory, so no relink is needed.
