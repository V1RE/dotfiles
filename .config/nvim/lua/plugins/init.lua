vim.cmd [[packadd packer.nvim]]
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
	execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
	execute 'packadd packer.nvim'
end

vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

return require('packer').startup(function(use)
	-- Packer can manage itself as an optional plugin
	use 'wbthomason/packer.nvim'

	-- Treesitter
	use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
	use 'nvim-treesitter/nvim-treesitter-refactor'
	use 'p00f/nvim-ts-rainbow'

	-- File explorer
	use 'kyazdani42/nvim-tree.lua'

	-- Colors
	use 'sainnhe/sonokai'
	use 'norcalli/nvim-colorizer.lua'
	use 'sheerun/vim-polyglot'

	-- Navigation
	use 'phaazon/hop.nvim'

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
	use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}

	-- General Plugins
	use 'psliwka/vim-smoothie'
	use {
    'AckslD/nvim-whichkey-setup.lua',
    requires = {'liuchengxu/vim-which-key'},
	}
end)

