---@type LazyPluginSpec[]
local M = {
  { "L3MON4D3/LuaSnip", name = "lua-snip", dependencies = { "friendly-snippets" } },
  { "Lilja/vim-chezmoi" },
  { "MunifTanjim/nui.nvim" },
  { "NvChad/nvim-colorizer.lua" },
  { "RRethy/vim-illuminate" },
  { "alker0/chezmoi.vim" },
  { "antoinemadec/FixCursorHold.nvim" },
  { "b0o/schemastore.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "cshuaimin/ssr.nvim" },
  { "f-person/git-blame.nvim" },
  { "famiu/bufdelete.nvim" },
  { "folke/which-key.nvim" },
  { "ghillb/cybu.nvim" },
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
  { "lewis6991/gitsigns.nvim" },
  { "luukvbaal/stabilize.nvim" },
  { "machakann/vim-sandwich" },
  { "max397574/colortils.nvim" },
  { "mbbill/undotree" },
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
  { "petertriho/nvim-scrollbar" },
  { "qpkorr/vim-renamer" },
  { "rafamadriz/friendly-snippets" },
  { "saadparwaiz1/cmp_luasnip" },
  { "stevearc/aerial.nvim" },
  { "tpope/vim-abolish" },
  { "tzachar/cmp-tabnine", build = "./install.sh", dependencies = { "nvim_cmp" } },
  { "wakatime/vim-wakatime" },
  { "williamboman/mason-lspconfig.nvim" },
  { "williamboman/mason.nvim" },
  { "windwp/nvim-autopairs" },
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
}

return M
