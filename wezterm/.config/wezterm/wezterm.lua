local wezterm = require("wezterm")

-- A helper function for my fallback fonts
local function font_with_fallback(name, params)
    local names = {
    name,
    "PragmataPro Mono Liga",
    "FiraCode Nerd Font",
    "codicon",
    "nonicons",
    "Noto Color Emoji",
    "JetBrains Mono",
    }
    return wezterm.font_with_fallback(names, params)
end

return {
  font = font_with_fallback("PragmataPro Mono Liga"),
  font_size = 18,
  color_scheme = "catppuccin",
  colors = require("colors.catppuccin"),
  hide_tab_bar_if_only_one_tab = true,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  keys = require("keys"),
  window_decorations = "RESIZE",
}
