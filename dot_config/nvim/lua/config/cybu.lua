local cybu_ok, cybu = pcall(require, "cybu")
if not cybu_ok then
	return
end

cybu.setup({
	position = {
		relative_to = "editor",
	},
	style = {
		path = "tail",
	},
	exclude = {
		"neo-tree",
		"fugitive",
		"qf",
		"NvimTree",
		"alpha",
	},
})
