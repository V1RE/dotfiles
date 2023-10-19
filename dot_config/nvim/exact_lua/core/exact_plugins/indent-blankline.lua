---@type LazyPluginSpec
local M = {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufReadPre",
  ---@type ibl.config
  opts = {
    indent = {
      char = "│",
    },
    exclude = {
      filetypes = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
    },
  },
}

return M
