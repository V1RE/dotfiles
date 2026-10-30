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

## Not migrated

The installed Herdr-app API has no legacy plugin compatibility:

- Cmd+P: termscope visible-screen link picker.
- Cmd+N: Sesh picker.
- Ctrl+H/J/K/L: vim-herdr-navigation (Vim-aware pane navigation).
- Cmd+B, Shift+S/A: Vercel Sandbox start/apply actions.

Cmd+P/N are explicitly passed to the terminal rather than silently invoking
unrelated app defaults. Ctrl+H/J/K/L remain available to terminal programs;
native pane navigation is still Cmd+Alt+arrows. These integrations need separate
ports, not bindings to nonexistent commands.

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
