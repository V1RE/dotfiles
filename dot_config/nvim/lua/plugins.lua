local fn = vim.fn
-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
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

return packer.startup(function(use)
  -- Package managers
  use("wbthomason/packer.nvim")
  use("williamboman/mason.nvim")

  -- Performance
  use("lewis6991/impatient.nvim")
  use("antoinemadec/FixCursorHold.nvim")

  -- Util libraries
  use("nvim-lua/plenary.nvim")

  -- UI libraries
  use("MunifTanjim/nui.nvim")
  use("nvim-lua/popup.nvim")
  use("stevearc/dressing.nvim")

  -- Time management
  use("wakatime/vim-wakatime")

  -- Terminal
  use("akinsho/toggleterm.nvim")

  -- Text manipulation
  use("machakann/vim-sandwich")
  use("tpope/vim-abolish")
  use("gbprod/yanky.nvim")

  -- Color helpers
  use("NvChad/nvim-colorizer.lua")
  use("max397574/colortils.nvim")

  use("kyazdani42/nvim-web-devicons")

  -- File management
  use("kyazdani42/nvim-tree.lua")
  use("qpkorr/vim-renamer")

  -- Chezmoi helpers
  use("alker0/chezmoi.vim")
  use("Lilja/vim-chezmoi")

  -- Buffer management
  use("moll/vim-bbye")
  use("nvim-lualine/lualine.nvim")
  use("ghillb/cybu.nvim")

  -- Eye candy
  use("RRethy/vim-illuminate")
  use("lukas-reineke/indent-blankline.nvim")
  use("petertriho/nvim-scrollbar")

  -- Movement
  use("phaazon/hop.nvim")
  use("jinh0/eyeliner.nvim")

  -- Colorschemes
  use({ "catppuccin/nvim", as = "catppuccin" })
  use("jascha030/nitepal.nvim")

  -- Snippets
  use({ "L3MON4D3/LuaSnip", as = "lua-snip" })
  use("rafamadriz/friendly-snippets")

  use({
    "zbirenbaum/copilot.lua",
    after = { "nvim-lspconfig" },
    event = { "VimEnter" },
    config = function()
      require("config.copilot_rc")
    end,
  })

  -- Cmp plugins
  use({
    "hrsh7th/nvim-cmp",
    as = "nvim_cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
    },
  })
  use({ "tzachar/cmp-tabnine", run = "./install.sh", requires = "nvim_cmp" })
  use({
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua", "nvim_cmp" },
    config = function()
      require("copilot_cmp").setup()
    end,
  })

  -- LSP
  use("neovim/nvim-lspconfig")
  use("williamboman/mason-lspconfig.nvim")
  use("folke/neodev.nvim")
  use("folke/neoconf.nvim")
  use("jose-elias-alvarez/null-ls.nvim")
  use("b0o/schemastore.nvim")
  use("jose-elias-alvarez/typescript.nvim")
  use("mfussenegger/nvim-jdtls")
  use("stevearc/aerial.nvim")
  use("windwp/nvim-autopairs")
  use("ahmedkhalf/project.nvim")
  use("lvimuser/lsp-inlayhints.nvim")

  -- Telescope
  use("nvim-telescope/telescope.nvim")
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
  use("nvim-telescope/telescope-ui-select.nvim")
  use("nvim-telescope/telescope-file-browser.nvim")
  use("ThePrimeagen/harpoon")

  -- Treesitter
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use("nvim-treesitter/playground")
  use("JoosepAlviste/nvim-ts-context-commentstring")
  use("windwp/nvim-ts-autotag")
  use("mizlan/iswap.nvim")
  use("monaqa/dial.nvim")
  use("nvim-treesitter/nvim-treesitter-context")
  use("numToStr/Comment.nvim")
  use({ "cshuaimin/ssr.nvim", module = "ssr" })

  -- Git
  use("lewis6991/gitsigns.nvim")
  use("f-person/git-blame.nvim")

  -- Keybindings
  use("folke/which-key.nvim")

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
