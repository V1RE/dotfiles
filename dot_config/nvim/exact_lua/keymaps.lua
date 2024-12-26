local util = require("core.util")
local opts = { silent = true }

-- Shorten function name
local function keymap(mode, lhs, rhs)
  vim.keymap.set(mode, lhs, rhs, opts)
end

--Remap space as leader key
keymap("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Resize with arrows
keymap("n", "<Up>", ":resize -2<CR>")
keymap("n", "<Down>", ":resize +2<CR>")
keymap("n", "<Left>", ":vertical resize -2<CR>")
keymap("n", "<Right>", ":vertical resize +2<CR>")

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi")
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi")

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==")
keymap("v", "<A-k>", ":m .-2<CR>==")
-- keymap("v", "p", '"_dP')

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv")
keymap("x", "K", ":move '<-2<CR>gv-gv")
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv")
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv")

-- vim.keymap.set("n", "<leader>gg", function()
--   util.float_term({ "lazygit" })
-- end, { desc = "Lazygit (cwd)" })

vim.keymap.set("n", "<leader>gG", function()
  util.float_term({ "lazygit" }, { cwd = util.get_root() })
end, { desc = "Lazygit (root dir)" })

-- vim.keymap.set("n", "<C-Space>", function()
--   util.float_term(nil, { cwd = util.get_root(), interactive = true })
-- end, { desc = "Terminal (root dir)" })
