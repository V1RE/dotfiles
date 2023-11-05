---@type LazyPluginSpec
local M = {
  "trunk-io/neovim-trunk",
  lazy = false,
  opts = {},
  main = "trunk",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
}

return M
