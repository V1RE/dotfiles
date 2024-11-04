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
  { "tzachar/cmp-tabnine", build = "./install.sh", dependencies = { "nvim-cmp" }, enabled = false },
  { "williamboman/mason-lspconfig.nvim" },
  { "williamboman/mason.nvim" },
  { "justinsgithub/wezterm-types" },
}

return M
