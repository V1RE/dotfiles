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

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use("wbthomason/packer.nvim")
  use("nvim-lua/popup.nvim")
  use("nvim-lua/plenary.nvim")
  use("MunifTanjim/nui.nvim")
  use("machakann/vim-sandwich")
  use("wakatime/vim-wakatime")
  use("tpope/vim-abolish")
  use("voldikss/vim-floaterm")
  use("phaazon/hop.nvim")
  use("windwp/nvim-autopairs")
  use("numToStr/Comment.nvim")
  use("SmiteshP/nvim-navic")
  use("NvChad/nvim-colorizer.lua")
  use("kyazdani42/nvim-web-devicons")
  use("https://git.sr.ht/~whynothugo/lsp_lines.nvim")
  use({
    "anuvyklack/windows.nvim",
    requires = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    config = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require("windows").setup()
    end,
  })
  use("kyazdani42/nvim-tree.lua")
  use("akinsho/bufferline.nvim")
  use("alker0/chezmoi.vim")
  use("Lilja/vim-chezmoi")
  use("moll/vim-bbye")
  use("nvim-lualine/lualine.nvim")
  use("akinsho/toggleterm.nvim")
  use("ahmedkhalf/project.nvim")
  use("ghillb/cybu.nvim")
  use("lewis6991/impatient.nvim")
  use("RRethy/vim-illuminate")
  use("lukas-reineke/indent-blankline.nvim")
  use("antoinemadec/FixCursorHold.nvim")
  use("stevearc/dressing.nvim")
  use("b0o/incline.nvim")
  --[[ use("rcarriga/nvim-notify") ]]
  use("max397574/colortils.nvim")
  use("unblevable/quick-scope")
  use("petertriho/nvim-scrollbar")

  -- Colorschemes
  use({ "catppuccin/nvim", as = "catppuccin" })
  use("jascha030/nitepal.nvim")

  -- snippets
  use({ "L3MON4D3/LuaSnip", as = "lua-snip" })
  use("rafamadriz/friendly-snippets")

  --[[ use("github/copilot.vim") ]]
  use({
    "zbirenbaum/copilot.lua",
    after = { "nvim-lspconfig" },
    event = { "VimEnter" },
    config = function()
      require("config.copilot.rc")
    end,
  })

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
  use("folke/lua-dev.nvim")
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")
  use("jose-elias-alvarez/null-ls.nvim")
  use("b0o/schemastore.nvim")
  use("jose-elias-alvarez/typescript.nvim")
  use("ray-x/lsp_signature.nvim")

  -- Telescope
  use("nvim-telescope/telescope.nvim")
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
  use("nvim-telescope/telescope-ui-select.nvim")
  use("ThePrimeagen/refactoring.nvim")
  use("nvim-telescope/telescope-file-browser.nvim")
  use({
    "nvim-telescope/telescope-frecency.nvim",
    requires = { "tami5/sqlite.lua" },
  })
  use("nvim-telescope/telescope-smart-history.nvim")
  use("s1n7ax/nvim-window-picker")
  use("ThePrimeagen/harpoon")

  -- Treesitter
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use("JoosepAlviste/nvim-ts-context-commentstring")
  use("windwp/nvim-ts-autotag")
  use("mizlan/iswap.nvim")
  use("monaqa/dial.nvim")
  use("nvim-treesitter/nvim-treesitter-context")

  -- Git
  use("lewis6991/gitsigns.nvim")
  use("TimUntersberger/neogit")

  use("mrjones2014/legendary.nvim")
  use("lvimuser/lsp-inlayhints.nvim")
  use("folke/which-key.nvim")

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
