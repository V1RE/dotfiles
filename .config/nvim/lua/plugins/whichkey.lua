local wk = require('whichkey_setup')

local keymap = {}

vim.g.which_key_display_names = {
    ['<CR>'] = '↵',
    ['<TAB>'] = '⇆',
}

vim.g.which_key_sep = '→'
vim.g.which_key_timeout = 100
vim.g.which_key_use_floating_win = 0
vim.g.which_key_max_size = 0

keymap.w = {':w<CR>', 'save file'}
keymap.q = {':BufferPrevious<CR>', 'prev buffer'}
keymap.e = {':BufferNext<CR>', 'next buffer'}
keymap.d = {':BufferClose<CR>', 'close buffer'}

wk.register_keymap('leader', keymap)
