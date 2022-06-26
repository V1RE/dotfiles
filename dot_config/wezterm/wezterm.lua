local wezterm = require("wezterm")

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
	font_size = 18,
	color_scheme = "catppuccin",
	colors = require("colors.catppuccin"),
	hide_tab_bar_if_only_one_tab = true,
	term = "wezterm",
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	keys = {
		{
			key = "[",
			mods = "CMD",
			action = {
				Multiple = { { SendKey = { key = "b", mods = "CTRL" } }, { SendKey = { key = "h", mods = "CTRL" } } },
			},
		},
		{
			key = "]",
			mods = "CMD",
			action = {
				Multiple = { { SendKey = { key = "b", mods = "CTRL" } }, { SendKey = { key = "l", mods = "CTRL" } } },
			},
		},
		-- { key = "t", mods = "CMD", action = "DisableDefaultAssignment" },
		-- { key = "w", mods = "CMD", action = "DisableDefaultAssignment" },
		{
			key = "Space",
			mods = "CTRL",
			action = wezterm.action.ShowLauncherArgs({
				flags = "FUZZY|WORKSPACES",
			}),
		},
	},
	window_decorations = "RESIZE",
}
