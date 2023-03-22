local wezterm = require("wezterm")
local act = wezterm.action

-- A helper function for my fallback fonts
local function font_with_fallback(name, params)
  local names = {
    name,
    "nielsicon",
    "CaskaydiaCove Nerd Font",
    "PragmataPro Liga",
    "PragmataPro Mono Liga",
    "Noto Color Emoji",
    "JetBrains Mono",
  }
  return wezterm.font_with_fallback(names, params)
end

local function isViProcess(pane)
  local name = "" .. pane:get_foreground_process_name()

  return name:find("n?vim") ~= nil or name:find("chezmoi") ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
  if isViProcess(pane) then
    window:perform_action(act.SendKey({ key = vim_direction, mods = "CTRL" }), pane)
  else
    window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
  end
end

wezterm.on("ActivatePaneDirection-right", function(window, pane)
  conditionalActivatePane(window, pane, "Right", "l")
end)
wezterm.on("ActivatePaneDirection-left", function(window, pane)
  conditionalActivatePane(window, pane, "Left", "h")
end)
wezterm.on("ActivatePaneDirection-up", function(window, pane)
  conditionalActivatePane(window, pane, "Up", "k")
end)
wezterm.on("ActivatePaneDirection-down", function(window, pane)
  conditionalActivatePane(window, pane, "Down", "j")
end)

wezterm.on("update-right-status", function(window, pane)
  window:set_right_status(pane:get_foreground_process_name() or "")
end)

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.font_dirs = { "fonts" }
config.font = font_with_fallback("Cascadia Code")
config.font_size = 16
config.line_height = 1.4

config.use_fancy_tab_bar = true

-- merge two lua
local old_config = {
  font_size = 16,
  line_height = 1.4,
  color_scheme_dirs = { "./colors/" },
  color_scheme = "onedarker",
  hide_tab_bar_if_only_one_tab = true,
  term = "wezterm",
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = false,
  window_background_opacity = 1,
  leader = {
    key = "b",
    mods = "CMD",
  },
  keys = {
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
      action = act.ShowLauncherArgs({
        flags = "FUZZY|WORKSPACES",
      }),
    },
    {
      key = "p",
      mods = "CMD",
      action = wezterm.action({
        QuickSelectArgs = {
          patterns = {
            "https?://\\S+",
          },
          action = wezterm.action_callback(function(window, pane)
            local url = window:get_selection_text_for_pane(pane)
            wezterm.log_info("opening: " .. url)
            wezterm.open_with(url)
          end),
        },
      }),
    },
  },
  window_decorations = "RESIZE",
  hyperlink_rules = {
    -- Linkify things that look like URLs and the host has a TLD name.
    {
      regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
      format = "$0",
    },

    -- linkify email addresses
    {
      regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
      format = "mailto:$0",
    },

    -- file:// URI
    {
      regex = [[\bfile://\S*\b]],
      format = "$0",
    },

    -- Linkify things that look like URLs with numeric addresses as hosts.
    -- E.g. http://127.0.0.1:8000 for a local development server,
    -- or http://192.168.1.1 for the web interface of many routers.
    {
      regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
      format = "$0",
    },

    -- Make username/project paths clickable. This implies paths like the following are for GitHub.
    -- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
    -- As long as a full URL hyperlink regex exists above this it should not match a full URL to
    -- GitHub or GitLab / BitBucket (i.e. https://gitlab.com/user/project.git is still a whole clickable URL)
    {
      regex = [["([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)"]],
      format = "https://www.github.com/$1/$3",
    },
  },
}

for k, v in pairs(old_config) do
  if config[k] == nil then
    config[k] = v
  end
end

return config
