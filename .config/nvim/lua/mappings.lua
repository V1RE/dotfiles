--[[
--
-- https://github.com/junegunn/fzf/issues/453
--
]]--

-- Clear spacebar keybinds and set mapleader
vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', {noremap = true, silent = true})
vim.g.mapleader = ' '

-- Quickly scrolling through file
vim.api.nvim_set_keymap('n', 'J', '5j', {noremap = true})
vim.api.nvim_set_keymap('v', 'J', '5j', {noremap = true})
vim.api.nvim_set_keymap('n', 'K', '5k', {noremap = true})
vim.api.nvim_set_keymap('v', 'K', '5k', {noremap = true})
vim.api.nvim_set_keymap('n', 'H', '^', {noremap = true})
vim.api.nvim_set_keymap('v', 'H', '^', {noremap = true})
vim.api.nvim_set_keymap('n', 'L', '$', {noremap = true})
vim.api.nvim_set_keymap('v', 'L', '$', {noremap = true})

-- Easy homerow insertmode escape
vim.api.nvim_set_keymap('i', 'jj', '<ESC>', {noremap = true, silent = true})

-- Toggle search highlight
vim.api.nvim_set_keymap('n', '\\', ':set hlsearch!<CR>', {noremap = true, silent = true})

-- Shortcut to enter command
vim.api.nvim_set_keymap('n', ';', ':', {noremap = true})
vim.api.nvim_set_keymap('v', ';', ':', {noremap = true})

-- Nvim tree mappings
vim.api.nvim_set_keymap('n', '<leader>n', ':NvimTreeFindFile<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>N', ':NvimTreeClose<cr>', {noremap = true})

-- Open Telescope
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope buffers<cr>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>or', ':luafile ~/.config/nvim/init.lua<cr>', {noremap = true, silent = true})

-- better window movement
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {silent = true})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {silent = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {silent = true})
