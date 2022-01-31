local wezterm = require("wezterm")

return {
	font = wezterm.font_with_fallback({ "PragmataPro Mono Liga", "FiraCode Nerd Font" }),
	font_size = 18,
	color_scheme = "onedarker",
	hide_tab_bar_if_only_one_tab = true,
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
}
