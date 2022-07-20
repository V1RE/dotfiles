local fn = vim.fn
-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Use a protected call so we don't error out on first use
local packer_ok, packer = pcall(require, "packer")
if not packer_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
		keybindings = {
			quit = "<esc>",
		},
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- My plugins here
	use("wbthomason/packer.nvim")
	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")
	use("MunifTanjim/nui.nvim")

	use("machakann/vim-sandwich")

	use("wakatime/vim-wakatime")

	use({
		"ptzz/lf.vim",
		config = require("config.lf"),
	})

	use("tpope/vim-abolish")

	use("voldikss/vim-floaterm")

	use({
		"phaazon/hop.nvim",
		config = require("config.hop-nvim"),
	})

	use({
		"windwp/nvim-autopairs",
		config = require("config.autopairs"),
	})

	use({
		"numToStr/Comment.nvim",
		config = require("config.comment"),
	})

	use({
		"SmiteshP/nvim-navic",
		config = require("config.navic"),
	})

	use({
		"norcalli/nvim-colorizer.lua",
		config = require("config.colorizer"),
	})

	use({
		"kyazdani42/nvim-web-devicons",
		config = require("config.webdevicons"),
	})

	use({
		"kyazdani42/nvim-tree.lua",
		config = require("config.nvim-tree"),
	})

	use({
		"akinsho/bufferline.nvim",
		config = require("config.bufferline"),
	})

	use("alker0/chezmoi.vim")

	use("moll/vim-bbye")

	use({
		"nvim-lualine/lualine.nvim",
		config = require("config.lualine"),
	})

	use({
		"akinsho/toggleterm.nvim",
		config = require("config.toggleterm"),
	})

	use({
		"ahmedkhalf/project.nvim",
		config = require("config.project"),
	})

	use({
		"ghillb/cybu.nvim",
		config = require("config.cybu"),
	})

	use("lewis6991/impatient.nvim")

	use("RRethy/vim-illuminate")

	use({
		"lvimuser/lsp-inlayhints.nvim",
		config = require("config.lsp-inlayhints"),
	})

	use({
		"lukas-reineke/indent-blankline.nvim",
		config = require("config.indentline"),
	})

	use("antoinemadec/FixCursorHold.nvim")
	use("christoomey/vim-tmux-navigator")

	use({
		"goolord/alpha-nvim",
		config = require("config.alpha"),
	})

	use({
		"stevearc/dressing.nvim",
		config = require("config.dressing"),
	})

	-- Colorschemes
	--use("lunarvim/darkplus.nvim")
	--use("lunarvim/onedarker.nvim")
	--use("EdenEast/nightfox.nvim")
	use({
		"catppuccin/nvim",
		as = "catppuccin",
		config = require("config.catppuccin-nvim"),
	})

	-- snippets
	use({
		"L3MON4D3/LuaSnip",
		config = require("config.luasnippets"),
	})

	-- cmp plugins
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-emoji",
		},
		config = require("config.cmp"),
	})

	use({
		"tzachar/cmp-tabnine",
		config = require("config.tabnine"),

		run = "./install.sh",
		requires = "hrsh7th/nvim-cmp",
	})

	use("rafamadriz/friendly-snippets")

	-- LSP
	use({
		"neovim/nvim-lspconfig",
		config = require("config.lsp"),
	})

	use("folke/lua-dev.nvim")

	use("williamboman/nvim-lsp-installer")

	use("tamago324/nlsp-settings.nvim")

	use("jose-elias-alvarez/null-ls.nvim")

	use("b0o/schemastore.nvim")

	use({
		"b0o/incline.nvim",
		config = require("config.incline"),
	})

	use({
		"ray-x/lsp_signature.nvim",
		config = require("config.signature"),
	})

	use({
		"tami5/lspsaga.nvim",
		config = require("config.lspsaga"),
	})

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		config = require("config.telescope"),
	})

	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "make",
	})

	use({ "nvim-telescope/telescope-ui-select.nvim" })

	use({ "nvim-telescope/telescope-file-browser.nvim" })

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = require("config.treesitter"),
	})
	use("JoosepAlviste/nvim-ts-context-commentstring")
	use("windwp/nvim-ts-autotag")
	use("mizlan/iswap.nvim")

	use({
		"monaqa/dial.nvim",
		config = require("config.dial"),
	})

	use({
		"j-hui/fidget.nvim",
		config = require("config.fidget"),
	})

	use({
		"folke/trouble.nvim",
		config = require("config.trouble"),
	})

	-- Git
	use({
		"lewis6991/gitsigns.nvim",
		config = require("config.gitsigns"),
	})

	use({
		"mrjones2014/legendary.nvim",
		config = require("config.legendary-nvim"),
	})

	use({
		"folke/which-key.nvim",
		config = require("config.whichkey"),
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
