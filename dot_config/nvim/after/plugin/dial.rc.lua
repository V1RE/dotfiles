local augend = require("dial.augend")
local map = require("dial.map")

require("dial.config").augends:register_group({
	default = {
		augend.integer.alias.decimal,
		augend.integer.alias.hex,
		augend.integer.alias.binary,
		augend.constant.alias.bool,
		augend.constant.new({
			elements = { "public", "private" },
			word = true,
			cyclic = true,
		}),
		augend.constant.new({
			elements = { "&&", "||" },
			word = false,
			cyclic = true,
		}),
		augend.date.alias["%Y/%m/%d"],
		augend.date.alias["%Y-%m-%d"],
		augend.date.alias["%H:%M:%S"],
		augend.hexcolor.new({ case = "lower" }),
		augend.semver.alias.semver,
	},
})

vim.keymap.set("n", "<C-a>", map.inc_normal())
vim.keymap.set("n", "<C-x>", map.dec_normal())
vim.keymap.set("v", "<C-a>", map.inc_visual())
vim.keymap.set("v", "<C-x>", map.dec_visual())
vim.keymap.set("v", "g<C-a>", map.inc_gvisual())
vim.keymap.set("v", "g<C-x>", map.dec_gvisual())
