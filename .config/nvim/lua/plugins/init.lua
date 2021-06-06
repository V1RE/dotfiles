vim.cmd [[packadd packer.nvim]]
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
	execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
	execute 'packadd packer.nvim'
end

vim.cmd 'autocmd BufWritePost plugins/init.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

return require('packer').startup(function(use)
	-- Packer can manage itself as an optional plugin
	use 'wbthomason/packer.nvim'

	-- LSP related plugins
	use 'neovim/nvim-lspconfig'
	use 'kabouzeid/nvim-lspinstall'
	use 'onsails/lspkind-nvim'
  use 'kosayoda/nvim-lightbulb'
	use 'glepnir/lspsaga.nvim'
	use 'ray-x/lsp_signature.nvim'

	-- Autocompletion
	-- use 'hrsh7th/nvim-compe'
	-- use 'hrsh7th/vim-vsnip'
	use 'rafamadriz/friendly-snippets'
	-- use {'tzachar/compe-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-compe'}
	use 'mattn/emmet-vim'
	use {'neoclide/coc.nvim', branch = 'release'}

	-- Treesitter
	use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
	use 'nvim-treesitter/nvim-treesitter-refactor'
	use 'p00f/nvim-ts-rainbow'

	-- File explorer
	use 'kyazdani42/nvim-tree.lua'

	-- Colors
	use 'sainnhe/sonokai'
	use 'christianchiarulli/nvcode-color-schemes.vim'
	use 'norcalli/nvim-colorizer.lua'
	use 'sheerun/vim-polyglot'
	use 'romgrk/doom-one.vim'

	-- Navigation
	use 'phaazon/hop.nvim'
	use 'andymass/vim-matchup'

	-- Icons
	use 'kyazdani42/nvim-web-devicons'
	use 'ryanoasis/vim-devicons'

	-- Status Line and Bufferline
	use 'glepnir/galaxyline.nvim'
	use 'romgrk/barbar.nvim'

	-- Telescope
	use 'nvim-lua/popup.nvim'
	use 'nvim-lua/plenary.nvim'
	use 'nvim-telescope/telescope.nvim'

	-- Git
	use 'kdheepak/lazygit.nvim'
	use 'lewis6991/gitsigns.nvim'
	use 'f-person/git-blame.nvim'

	-- General Plugins
	use 'christoomey/vim-tmux-navigator'
	use 'liuchengxu/vim-which-key'
	use 'jiangmiao/auto-pairs'
	use 'AckslD/nvim-whichkey-setup.lua'
	use 'voldikss/vim-floaterm'
	use 'wakatime/vim-wakatime'
	use 'tpope/vim-surround'
	use 'tpope/vim-commentary'
	use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install' }

	-- PHP
	use {'phpactor/phpactor', run = 'composer install --no-dev -o'}
	use 'beanworks/vim-phpfmt'

	-- TypeScript
	use 'HerringtonDarkholme/yats.vim'
end)

