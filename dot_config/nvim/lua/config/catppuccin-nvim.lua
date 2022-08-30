local catppuccin_ok, catppuccin = pcall(require, "catppuccin")
if not catppuccin_ok then
	return
end

catppuccin.setup({
	transparent_background = false,
	term_colors = true,
	styles = {
		comments = {"italic"},
		functions = {"italic"},
		keywords = {"italic"},
		strings = {},
		variables = {},
	},
})

require("colorscheme")
