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
local packer_ok = pcall(require, "packer")
if not packer_ok then
  return
end

local packer = require("packer")

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
  use("ptzz/lf.vim")
  use("tpope/vim-abolish")
  use("voldikss/vim-floaterm")
  use("phaazon/hop.nvim")
  use("windwp/nvim-autopairs")
  use("numToStr/Comment.nvim")
  use("SmiteshP/nvim-navic")
  use("norcalli/nvim-colorizer.lua")
  use("kyazdani42/nvim-web-devicons")
  --[[ use("github/copilot.vim") ]]
  use("https://git.sr.ht/~whynothugo/lsp_lines.nvim")
  use("kyazdani42/nvim-tree.lua")
  use("akinsho/bufferline.nvim")
  use("alker0/chezmoi.vim")
  use("moll/vim-bbye")
  use("nvim-lualine/lualine.nvim")

  use({
    "akinsho/toggleterm.nvim",
    config = function()
      require("config.toggleterm")
    end,
  })

  use({
    "ahmedkhalf/project.nvim",
    config = function()
      require("config.project")
    end,
  })

  use({
    "ghillb/cybu.nvim",
    config = function()
      require("config.cybu")
    end,
  })

  use("lewis6991/impatient.nvim")

  use("RRethy/vim-illuminate")

  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("config.indentline")
    end,
  })

  use("antoinemadec/FixCursorHold.nvim")
  use("christoomey/vim-tmux-navigator")
  use("stevearc/dressing.nvim")

  -- Colorschemes
  use({ "catppuccin/nvim", as = "catppuccin" })

  -- snippets
  use({ "L3MON4D3/LuaSnip", as = "lua-snip" })

  use({ "zbirenbaum/copilot.lua", event = "InsertEnter" })

  -- cmp plugins
  use({
    "hrsh7th/nvim-cmp",
    as = "nvim_cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-emoji",
    },
  })

  use({ "tzachar/cmp-tabnine", run = "./install.sh", requires = "hrsh7th/nvim-cmp" })

  use({ "zbirenbaum/copilot-cmp", module = "copilot_cmp" })

  use("rafamadriz/friendly-snippets")

  -- LSP
  use({
    "neovim/nvim-lspconfig",
    config = function()
      require("config.lsp")
    end,
  })

  use("folke/lua-dev.nvim")
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")
  use("jose-elias-alvarez/null-ls.nvim")
  use("b0o/schemastore.nvim")
  use("jose-elias-alvarez/typescript.nvim")
  use("b0o/incline.nvim")
  use("ray-x/lsp_signature.nvim")

  -- Telescope
  use("nvim-telescope/telescope.nvim")
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
  use("nvim-telescope/telescope-ui-select.nvim")
  use("ThePrimeagen/refactoring.nvim")

  -- Treesitter
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use("JoosepAlviste/nvim-ts-context-commentstring")
  use("windwp/nvim-ts-autotag")
  use("mizlan/iswap.nvim")
  use("monaqa/dial.nvim")

  use("j-hui/fidget.nvim")

  -- Git
  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("config.gitsigns")
    end,
  })

  use({
    "mrjones2014/legendary.nvim",
    config = function()
      require("config.legendary-nvim")
    end,
  })

  use({
    "lvimuser/lsp-inlayhints.nvim",
    config = function()
      require("config.inlayhints")
    end,
  })

  use("folke/which-key.nvim")

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
