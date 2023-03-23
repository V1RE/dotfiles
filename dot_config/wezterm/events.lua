local wezterm = require("wezterm")
local act = wezterm.action

local function isViProcess(pane)
  local name = "" .. pane:get_foreground_process_name()

  return name:find("n?vim") ~= nil or name:find("chezmoi") ~= nil
end

local function conditionalActivatePane(pane_direction, vim_direction)
  return function(window, pane)
    if isViProcess(pane) then
      window:perform_action(act.SendKey({ key = vim_direction, mods = "CTRL" }), pane)
    else
      window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
    end
  end
end

wezterm.on("ActivatePaneDirection-right", conditionalActivatePane("Right", "l"))
wezterm.on("ActivatePaneDirection-left", conditionalActivatePane("Left", "h"))
wezterm.on("ActivatePaneDirection-up", conditionalActivatePane("Up", "k"))
wezterm.on("ActivatePaneDirection-down", conditionalActivatePane("Down", "j"))

wezterm.on("update-right-status", function(window, pane)
  window:set_right_status(pane:get_foreground_process_name() or "")
end)

wezterm.on("window-config-reloaded", function(window)
  window:toast_notification("Configuration loaded.", "", nil, 5000)
end)
