local wezterm = require("wezterm")

require("events")

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

local config = wezterm.config_builder()

config.font_dirs = { "fonts" }
config.font = font_with_fallback("Cascadia Code")
config.font_size = 14
config.line_height = 1.4
config.command_palette_font_size = 16

config.window_frame = {
  font_size = 16,
  font = wezterm.font("Roboto"),
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

-- merge two lua
local old_config = {
  color_scheme = "Molokai",
  term = "wezterm",
  window_background_opacity = 0.8,
  window_decorations = "RESIZE",
  hyperlink_rules = {
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
  },
}

for k, v in pairs(old_config) do
  if config[k] == nil then
    config[k] = v
  end
end

return config
