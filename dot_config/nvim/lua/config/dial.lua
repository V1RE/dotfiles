local dial_ok, dial = pcall(require, "dial.config")
if not dial_ok then
  return
end

local augend = require("dial.augend")

dial.augends:register_group({
  default = {
    augend.integer.alias.decimal,
    augend.integer.alias.hex,
    augend.integer.alias.binary,
    augend.date.alias["%Y/%m/%d"],
    augend.date.alias["%Y-%m-%d"],
    augend.date.alias["%H:%M:%S"],
    augend.hexcolor.new({ case = "lower" }),
    augend.semver.alias.semver,
  },
})

local map = require("dial.map")

vim.keymap.set("n", "<C-a>", map.inc_normal)
vim.keymap.set("n", "<C-x>", map.dec_normal)
vim.keymap.set("v", "<C-a>", map.inc_visual)
vim.keymap.set("v", "<C-x>", map.dec_visual)
vim.keymap.set("v", "g<C-a>", map.inc_gvisual)
vim.keymap.set("v", "g<C-x>", map.dec_gvisual)
