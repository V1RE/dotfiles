# Herdr-app migration

Personal configuration only; generated guides, types, shipped mods/layouts and
runtime state are intentionally not managed by chezmoi. The old Herdr and
Ghostty configurations stay intact.

## Migrated

- Cmd+H/L: previous/next tab; Cmd+J/K: next/previous space.
- Cmd+T/W: new/close tab; Cmd+M: the native space/tab/agent picker (goto).
- Cmd+B, then H/L: split right; J/K: split down (unmodified letters).
- Native legacy prefix defaults: X close pane, Z zoom, B sidebar, S settings,
  W picker, ? help, 1–9 tabs; Shift+N new space, Shift+W rename space,
  Shift+D close space, Shift+T rename tab. Esc/unknown keys cancel.
- Shift+Enter sends ESC followed by CR, matching Ghostty.
- Ghostty's primary font, CaskaydiaCove Nerd Font Mono; size 14 in Herdr-app.
  Herdr accepts one font family, not Ghostty's fallback/codepoint list.
- Catppuccin Macchiato palette copied from the installed Ghostty theme; fixed
  dark appearance, matching legacy Herdr's disabled automatic switching.
- Option acts as Alt; existing app sounds, zoom and contrast are preserved.
- Native tabs already open without asking for a name and follow the focused
  terminal's folder. Closing the last tab/space still asks for confirmation.

## Native integration ports

- Cmd+N: Sesh-style picker combining open app spaces and local zoxide history.
  Enter switches to an existing space or creates a named local space for the
  directory. Local paths are deduplicated; identical remote paths remain separate.
  Search accepts multiple terms and separators; Ctrl+S toggles alphabetical order.
  This ports the current setup (no Sesh TOML was present), not the old plugin's
  config/import/startup-command/window/clone/preview features.
- Cmd+P: Termscope-style HTTP(S) link picker. Enter opens the selected URL;
  Ctrl+Y copies it, Ctrl+S changes order, Esc cancels. Reads the source terminal
  once via `hc read`, never opens a URL without selection. The core's live screen
  is available, not Herdr-app's scrolled-back viewport or hidden OSC-8 targets.
- Ctrl+H/J/K/L: inspect the source terminal's foreground process. Vim receives
  the original key; other programs navigate app panes. Unknown process metadata
  preserves the key. Async replies never navigate a different focused terminal.
  These keys intentionally replace shell/TUI shortcuts outside Vim (e.g. Ctrl+L
  no longer clears the shell). Cmd+Alt+arrows remain native pane navigation.
- Neovim's Navigator mappings move through internal splits first, then call the
  local app at an edge. Normal and terminal mode are mapped. Restart Neovim or
  reload the Navigator plugin after installing. Outside herdr-core the original
  Navigator behavior remains unchanged. Classic Vim needs its own edge hook;
  remote Neovim cannot call the local window's CLI, so cross-pane edge navigation
  is currently local-only. Remote Vim still receives the Ctrl chords.

Mods use the installed core and zoxide, not the legacy plugin binaries. Shared
JavaScript lives in `.chezmoitemplates/herdr-app/`; chezmoi renders a copy inside
each mod because Herdr's module sandbox rejects imports outside that mod folder.
Navigation uses short-lived command overlays rather than altering shipped layouts.

Checks (from the repository root):

```sh
node --experimental-vm-modules --test tests/herdr-app.test.mjs
nvim --headless -u NONE -l tests/herdr-navigation.lua
```

## Not migrated

Cmd+B, Shift+S/A (Vercel Sandbox start/apply) remains unbound. The installed
Herdr-app API has no legacy plugin compatibility.

No documented settings equivalent exists for Ghostty's 40% cell/cursor height,
font-codepoint-map, blur, native-window opacity, mouse hiding or link previews.
Terminal opacity is not native-window transparency, so it is not substituted.
Padding/titlebar are layout-owned and shipped layouts are left untouched.

Legacy toast positions, clipboard toast, agent sorting/border labels, status
symbols, Cmd+right-click passthrough and scrollback/history/agent restoration/
SSH/update-channel settings cannot be copied into settings.json. They belong to
shipped mods, herdr-core, or lack a documented equivalent. Core keeps terminals
while the window closes; after core loss it restores shells, not agent sessions.
Kitty support and shell integration are provided by the new terminal/core;
the old experimental toggles are not app settings. No onboarding/runtime state
is overwritten.
