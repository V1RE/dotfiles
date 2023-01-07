local util = require("neodev.util")

require("neodev").setup({
	override = function(root_dir, library)
		if util.has_file(root_dir, "~/.local/share/chezmoi") or util.has_file(root_dir, "~/.config/nvim") then
			library.enabled = true
			library.plugins = true
		end
	end,
})
