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

wk.config{
    hide_statusline = true,
    default_keymap_settings = {
        silent=true,
        noremap=true,
    },
    default_mode = 'n',
}

-- Buffers
keymap.b = {
    name = '﬘ Buffer',
    w = {':w<CR>', ' Save'},
    p = {':BufferPrevious<CR>', 'ﰱ Previous'},
    n = {':BufferNext<CR>', 'ﰴ Next'},
    d = {':BufferClose<CR>', ' Close'},
    q = {':BufferCloseAllButCurrent<CR>:BufferClose<CR>', ' Close All'},
    f = {':BufferPick<CR>', '什 Pick'},
}

-- Telescope / searching
keymap.f = {
    name = ' Find',
    f = {':Telescope find_files<CR>', ' File'},
    b = {':Telescope buffers<CR>', '﬘ Buffer'},
    j = {':Telescope oldfiles<CR>', ' Recent'},
    k = {':Telescope builtin<CR>', ' Builtin'},
    t = {':Telescope grep_string<CR>', '縷 Text'},
    s = {':Telescope live_grep<CR>', '﬍ String'},
}

-- Sidebar
keymap.n = {
    name = 'פּ Sidebar',
    n = {':NvimTreeFindFile<CR>', ' Find Current'},
    t = {':NvimTreeToggle<CR>', ' Toggle'},
}

-- Config
keymap.o = {
    name = '煉 Config',
    r = {':luafile ~/.config/nvim/init.lua<CR>', '勒 Reload'},
    o = {':e ~/.config/nvim/init.lua<CR>', ' Open'},
		s = {':PackerSync<CR>', ' Sync Packages'},
}

-- Window commands
keymap.w = {
    name = '类 Window',
    d = {':q<CR>', ' Close'},
    q = {':qa<CR>', '﫧 Close All'},
    h = {':set nosr<CR>:vsp<CR>:set sr<CR><C-w>h', '溺 Split Left'},
    j = {':set sb<CR>:sp<CR>', '鱗 Split Down'},
    k = {':set nosb<CR>:sp<CR>:set sb<CR>', '麟 Split Up'},
    l = {':set sr<CR>:vsp<CR>', '匿 Split Right'},
}

-- Git commands
keymap.g = {
    name = ' Git',
    g = {':LazyGit<CR>', '鈴 LazyGit'},
}

wk.register_keymap('leader', keymap)
