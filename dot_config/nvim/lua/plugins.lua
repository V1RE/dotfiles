local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local status_lazy, lazy = pcall(require, "lazy")
if not status_lazy then
  return print("Lazy.nvim is not installed")
end

lazy.setup({
  "core/plugins",
  "JoosepAlviste/nvim-ts-context-commentstring",
  { "L3MON4D3/LuaSnip", name = "lua-snip", dependencies = { "friendly-snippets" } },
  { "Lilja/vim-chezmoi" },
  { "MunifTanjim/nui.nvim" },
  { "NvChad/nvim-colorizer.lua" },
  { "RRethy/vim-illuminate" },
  { "TimUntersberger/neogit" },
  { "ahmedkhalf/project.nvim" },
  { "alker0/chezmoi.vim" },
  { "antoinemadec/FixCursorHold.nvim" },
  { "b0o/schemastore.nvim" },
  { "catppuccin/nvim", as = "catppuccin" },
  { "cshuaimin/ssr.nvim" },
  { "f-person/git-blame.nvim" },
  { "famiu/bufdelete.nvim" },
  { "folke/neoconf.nvim" },
  { "folke/neodev.nvim" },
  { "folke/which-key.nvim" },
  { "gbprod/yanky.nvim" },
  { "ghillb/cybu.nvim" },
  { "goolord/alpha-nvim" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-path" },
  {
    "hrsh7th/nvim-cmp",
    name = "nvim_cmp",
    dependencies = { "cmp-buffer", "cmp-path", "cmp-nvim-lsp", "cmp_luasnip", "cmp-cmdline" },
  },
  { "j-hui/fidget.nvim" },
  { "jose-elias-alvarez/null-ls.nvim" },
  { "jose-elias-alvarez/typescript.nvim" },
  { "karb94/neoscroll.nvim" },
  { "kyazdani42/nvim-web-devicons" },
  { "lewis6991/gitsigns.nvim" },
  { "lukas-reineke/indent-blankline.nvim" },
  { "luukvbaal/stabilize.nvim" },
  { "machakann/vim-sandwich" },
  { "max397574/colortils.nvim" },
  { "mbbill/undotree" },
  { "mhogeveen/reach.nvim" },
  { "mizlan/iswap.nvim" },
  { "moll/vim-bbye" },
  { "monaqa/dial.nvim" },
  { "neovim/nvim-lspconfig", dependencies = { "mason-lspconfig.nvim" } },
  { "numToStr/Comment.nvim" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-lua/popup.nvim" },
  { "nvim-lualine/lualine.nvim" },
  { "nvim-telescope/telescope-file-browser.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  { "nvim-telescope/telescope-ui-select.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "telescope-fzf-native.nvim", "telescope-ui-select.nvim" },
    cmd = "Telescope",
  },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "nvim-treesitter/playground" },
  { "onsails/lspkind.nvim" },
  { "petertriho/nvim-scrollbar" },
  { "phaazon/hop.nvim" },
  { "qpkorr/vim-renamer" },
  { "rafamadriz/friendly-snippets" },
  { "saadparwaiz1/cmp_luasnip" },
  { "stevearc/aerial.nvim" },
  { "stevearc/dressing.nvim" },
  { "tpope/vim-abolish" },
  { "tzachar/cmp-tabnine", build = "./install.sh", dependencies = { "nvim_cmp" } },
  { "wakatime/vim-wakatime" },
  { "williamboman/mason-lspconfig.nvim" },
  { "williamboman/mason.nvim" },
  { "windwp/nvim-autopairs" },
  { "windwp/nvim-ts-autotag" },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    dependencies = { "nvim-lspconfig" },
    event = { "VimEnter" },
    config = function()
      require("config.copilot_rc")
    end,
  },
  { "hrsh7th/cmp-cmdline" },
})
