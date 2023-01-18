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

return {
  font_dirs = { "fonts" },
  font = font_with_fallback("Cascadia Code"),
  font_size = 16,
  line_height = 1.4,
  color_scheme = "Catppuccin Macchiato",
  hide_tab_bar_if_only_one_tab = true,
  term = "wezterm",
  -- window_padding = {
  --   left = 30,
  --   right = 30,
  --   top = 30,
  --   bottom = 15,
  -- },
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  -- window_background_opacity = 0.90,
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
