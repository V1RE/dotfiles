local npairs_ok, npairs = pcall(require, "nvim-autopairs")
local cmp_ok, cmp = pcall(require, "cmp")
local cmp_npairs_ok, cmp_npairs = pcall(require, "nvim-autopairs.completion.cmp")

if not (npairs_ok and cmp_ok and cmp_npairs_ok) then
	return
end

npairs.setup({
	check_ts = true,
	ts_config = {
		lua = { "string", "source" },
		javascript = { "string", "template_string" },
		java = false,
	},
	disable_filetype = { "TelescopePrompt", "spectre_panel" },
	fast_wrap = {
		map = "<M-e>",
		chars = { "{", "[", "(", '"', "'" },
		pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
		offset = 0, -- Offset from pattern match
		end_key = "$",
		keys = "qwertyuiopzxcvbnmasdfghjkl",
		check_comma = true,
		highlight = "PmenuSel",
		highlight_grey = "LineNr",
	},
})

cmp.event:on("confirm_done", cmp_npairs.on_confirm_done({ map_char = { tex = "" } }))
