---@type LazyPluginSpec[]
local M = {
  {
    "m4xshen/hardtime.nvim",
    enabled = false,
    opts = {
      disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "neo-tree" },
    },
  },
}

return M
