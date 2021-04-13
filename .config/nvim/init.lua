require('plugins')
require('settings')
require('mappings')
require('colorscheme')
require('autocmds')

require('plugins.telescope')
require('plugins.treesitter')
require('plugins.galaxyline')
require('plugins.nvimtree')
require('plugins.whichkey')
require('plugins.indentline')
require('plugins.gitsigns')
require('plugins.compe')
require('plugins.lspinstall')

require('lsp.typescript')

-- Autocommands
vim.cmd('source ~/.config/nvim/vimscript/autocmds.vim')
