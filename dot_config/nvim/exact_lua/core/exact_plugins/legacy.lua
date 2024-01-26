---@type LazyPluginSpec[]
local M = {
  { "MunifTanjim/nui.nvim" },
  { "b0o/schemastore.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "famiu/bufdelete.nvim" },
  { "folke/which-key.nvim" },
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
  { "karb94/neoscroll.nvim" },
  { "luukvbaal/stabilize.nvim" },
  { "mizlan/iswap.nvim" },
  { "moll/vim-bbye" },
  { "monaqa/dial.nvim" },
  { "neovim/nvim-lspconfig", dependencies = { "mason-lspconfig.nvim" } },
  { "nvim-lua/plenary.nvim" },
  { "saadparwaiz1/cmp_luasnip" },
  { "tpope/vim-abolish" },
  { "tzachar/cmp-tabnine", build = "./install.sh", dependencies = { "nvim_cmp" } },
  { "williamboman/mason-lspconfig.nvim" },
  { "williamboman/mason.nvim" },
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
