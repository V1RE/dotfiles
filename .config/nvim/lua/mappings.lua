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

-- Quickly hop to places
vim.api.nvim_set_keymap('n', '<Tab>', ':HopWord<CR>', {noremap = true, silent = true})

-- Easy homerow insertmode escape
vim.api.nvim_set_keymap('i', 'jj', '<ESC>', {noremap = true, silent = true})

-- Toggle search highlight
vim.api.nvim_set_keymap('n', '\\', ':set hlsearch!<CR>', {noremap = true, silent = true})

-- Shortcut to enter command
vim.api.nvim_set_keymap('n', ';', ':', {noremap = true})
vim.api.nvim_set_keymap('v', ';', ':', {noremap = true})

-- better window movement
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {silent = true})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {silent = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {silent = true})
