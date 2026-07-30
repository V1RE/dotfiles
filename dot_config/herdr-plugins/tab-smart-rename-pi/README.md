# herdr-tab-smart-rename-pi

**Tabs that say what the work is.** Named by Pi Coding Agent.

Smart Rename Pi turns numbered Herdr tabs into short task labels. Known
processes get instant names such as `Run Tests`, `Dev Server`, and `View Logs`.
Ambiguous work goes to **your own Pi installation** through the
[`@earendil-works/pi-coding-agent`](https://www.npmjs.com/package/@earendil-works/pi-coding-agent)
SDK: Pi's stored credentials, Pi's model catalog, Pi's default provider and
model. There is no API key to configure here. Manual names always win.

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
herdr plugin action invoke tab-smart-rename-pi.check-ai
herdr plugin action invoke tab-smart-rename-pi.start
```

`check-ai` prints the model Pi resolved, for example `openai/gpt-5.6-luna`, and
makes no request. If it fails, fix Pi itself: run `pi`, sign in or switch
provider, and confirm `pi -p "hi"` answers. Smart Rename uses exactly the
credentials and default model that `pi` uses, so anything that breaks one
breaks both.

Deterministic process names and workspace names need no model at all; only
ambiguous tabs depend on Pi being able to answer.

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
| `configure-ai` | Edit Smart Rename settings (timeout, prompt path) |
| `configure-prompt` | Edit naming instructions |
| `check-ai` | Report the resolved Pi model without calling it |
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

The model comes from Pi. Whatever `pi` would use — `defaultProvider` and
`defaultModel` in `~/.pi/agent/settings.json`, else Pi's provider default — is
what names your tabs, with the credentials in `~/.pi/agent/auth.json`. Change
the model in Pi, not here.

Only two plugin settings exist, with defaults from
[`provider.env.example`](provider.env.example):

```dotenv
SMART_RENAME_TIMEOUT_MS=45000
# SMART_RENAME_PROMPT_PATH=naming-prompt.md
```

Process environment wins over `provider.env`, which wins over the bundled
defaults. Config reloads before every model request.

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

Each naming request builds one throwaway `AgentSession` and disposes it. Pi
supplies credentials and model selection; everything else is stripped:

- `noTools: "all"` — the model cannot read files or run commands.
- `DefaultResourceLoader` with `noExtensions`, `noSkills`, `noPromptTemplates`,
  `noThemes`, and `noContextFiles` — no local Pi resources leak into the prompt.
- `systemPromptOverride` — the naming policy replaces Pi's coding-agent prompt.
- `SessionManager.inMemory()` — no session files, no transcript on disk.
- `cwd` is a private directory under the temp dir, so no repository context
  files or project-scoped settings are read.

`prompt()` takes no `AbortSignal`, so `SMART_RENAME_TIMEOUT_MS` aborts the
session, waits for the request to settle, and disposes it.

## Privacy

Model requests contain bounded, sanitized evidence from the dominant pane. Pi
panes may contribute short user-request excerpts; sibling panes contribute
process summaries only. Smart Rename removes terminal formatting, common secret
shapes, and the local home path before sending context.

Credentials stay inside Pi: the embedded `ModelRuntime` loads
`~/.pi/agent/auth.json` for the request, and Smart Rename never copies, stores,
or prints it. Provider errors pass through the same secret redaction as pane
output before reaching a notification or `worker.log`.

## Troubleshooting

- Worker stopped: `herdr plugin action invoke tab-smart-rename-pi.start`
- No model / 401 / quota errors: reproduce with `pi -p "hi"`. If that fails too,
  the fault is in Pi's own login or default model, not in this plugin. Fix it
  with `pi`, then rerun `check-ai`.
- `check-ai` never sends a request; it only reports what Pi resolved.
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
