local dial_ok, dial = pcall(require, "dial.map")
if not dial_ok then
	return
end

vim.keymap.set("n", "<C-a>", dial.inc_normal)
vim.keymap.set("n", "<C-x>", dial.dec_normal)
vim.keymap.set("v", "<C-a>", dial.inc_visual)
vim.keymap.set("v", "<C-x>", dial.dec_visual)
vim.keymap.set("v", "g<C-a>", dial.inc_gvisual)
vim.keymap.set("v", "g<C-x>", dial.dec_gvisual)
