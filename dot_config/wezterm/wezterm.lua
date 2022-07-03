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
		{ key = "t", mods = "CMD", action = "DisableDefaultAssignment" },
		{ key = "w", mods = "CMD", action = "DisableDefaultAssignment" },
		{ key = "h", mods = "CMD", action = act.ActivateTabRelative(-1) },
		{ key = "l", mods = "CMD", action = act.ActivateTabRelative(1) },
		{ key = "j", mods = "CMD", action = act.SwitchWorkspaceRelative(1) },
		{ key = "k", mods = "CMD", action = act.SwitchWorkspaceRelative(-1) },
		{
			key = "Enter",
			mods = "CTRL",
			action = act.ShowLauncher,
		},
	},
	window_decorations = "RESIZE",
}
