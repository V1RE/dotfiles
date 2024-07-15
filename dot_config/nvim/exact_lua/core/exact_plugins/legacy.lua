---@type LazyPluginSpec[]
local M = {
  { "MunifTanjim/nui.nvim" },
  { "b0o/schemastore.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "famiu/bufdelete.nvim" },
  { "j-hui/fidget.nvim" },
  { "nvimtools/none-ls.nvim" },
  { "karb94/neoscroll.nvim" },
  { "luukvbaal/stabilize.nvim" },
  { "mizlan/iswap.nvim" },
  { "moll/vim-bbye" },
  { "monaqa/dial.nvim" },
  { "neovim/nvim-lspconfig", dependencies = { "mason-lspconfig.nvim" } },
  { "nvim-lua/plenary.nvim" },
  { "tpope/vim-abolish" },
  { "tzachar/cmp-tabnine", build = "./install.sh", dependencies = { "nvim-cmp" } },
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
  { "justinsgithub/wezterm-types" },
}

return M
