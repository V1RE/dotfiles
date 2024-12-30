local wezterm = require("wezterm")
local act = wezterm.action

local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

local M = {
  { key = "l", mods = "LEADER", action = act.SplitPane({
    direction = "Right",
  }) },
  { key = "k", mods = "LEADER", action = act.SplitPane({
    direction = "Up",
  }) },
  { key = "h", mods = "LEADER", action = act.SplitPane({
    direction = "Left",
  }) },
  { key = "j", mods = "LEADER", action = act.SplitPane({
    direction = "Down",
  }) },
  { key = "h", mods = "CTRL", action = act.EmitEvent("ActivatePaneDirection-left") },
  { key = "j", mods = "CTRL", action = act.EmitEvent("ActivatePaneDirection-down") },
  { key = "k", mods = "CTRL", action = act.EmitEvent("ActivatePaneDirection-up") },
  { key = "l", mods = "CTRL", action = act.EmitEvent("ActivatePaneDirection-right") },
  { key = "h", mods = "CMD", action = act.ActivateTabRelative(-1) },
  { key = "l", mods = "CMD", action = act.ActivateTabRelative(1) },
  { key = "j", mods = "CMD", action = act.SwitchWorkspaceRelative(1) },
  { key = "k", mods = "CMD", action = act.SwitchWorkspaceRelative(-1) },
  {
    key = "m",
    mods = "CMD",
    action = act.ShowLauncherArgs({
      flags = "FUZZY",
    }),
  },
  {
    key = "n",
    mods = "CMD",
    action = workspace_switcher.switch_workspace(),
  },
  {
    key = "p",
    mods = "CMD",
    action = act.QuickSelectArgs({
      patterns = {
        "https?://\\S+",
      },

      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.log_info("opening: " .. url)
        wezterm.open_with(url)
      end),
    }),
  },
}

return M
