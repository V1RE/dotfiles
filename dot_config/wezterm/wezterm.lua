---@diagnostic disable: missing-fields
local wezterm = require("wezterm") --[[@as Wezterm]]

require("events")

-- A helper function for my fallback fonts
local function font_with_fallback(name)
  local names = {
    name,
    "nielsicon",
    "CaskaydiaCove Nerd Font",
    "PragmataPro Liga",
    "PragmataPro Mono Liga",
    "Noto Color Emoji",
    "JetBrains Mono",
  }
  return wezterm.font_with_fallback(names)
end

local config = wezterm.config_builder()

config.font_dirs = { "fonts" }
config.font = font_with_fallback("Cascadia Code")
config.font_size = 16
config.line_height = 1.4
config.command_palette_font_size = 16

config.front_end = "WebGpu"
config.max_fps = 120

config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

config.window_frame = {
  font_size = 16,
  font = wezterm.font({ family = "Roboto" }),
}

config.pane_focus_follows_mouse = true

config.leader = {
  key = "b",
  mods = "CMD",
}
config.keys = require("keys")

config.macos_window_background_blur = 30
-- config.color_scheme = "Molokai"
config.color_scheme = "Catppuccin Mocha"

wezterm.plugin.require("https://github.com/nekowinston/wezterm-bar").apply_to_config(config, {
  position = "top",
  dividers = "slant_left",
  indicator = {
    leader = {
      off = " ",
      on = " ",
    },
  },
})

wezterm.plugin.require("https://github.com/catppuccin/wezterm").apply_to_config(config)

local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

workspace_switcher.zoxide_path = "/opt/homebrew/bin/zoxide"

workspace_switcher.apply_to_config(config)

config.term = "wezterm"
config.window_background_opacity = 0.8
config.window_decorations = "RESIZE"
config.hyperlink_rules = {
  -- Linkify things that look like URLs and the host has a TLD name.
  { regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b", format = "$0" },
  -- linkify email addresses
  { regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]], format = "mailto:$0" },
  -- file:// URI
  { regex = [[\bfile://\S*\b]], format = "$0" },
  -- Linkify things that look like URLs with numeric addresses as hosts.
  -- E.g. http://127.0.0.1:8000 for a local development server,
  -- or http://192.168.1.1 for the web interface of many routers.
  { regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]], format = "$0" },
  -- Make username/project paths clickable. This implies paths like the following are for GitHub.
  -- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
  -- As long as a full URL hyperlink regex exists above this it should not match a full URL to
  -- GitHub or GitLab / BitBucket (i.e. https://gitlab.com/user/project.git is still a whole clickable URL)
  { regex = [["([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)"]], format = "https://www.github.com/$1/$3" },
}

return config
