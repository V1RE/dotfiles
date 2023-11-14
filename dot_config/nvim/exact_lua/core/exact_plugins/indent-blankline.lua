---@type LazyPluginSpec
local M = {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufReadPre",
  main = "ibl",
  ---@type ibl.config
  opts = {
    indent = { char = "│" },
    scope = { enabled = true },
    exclude = { filetypes = { "help", "neo-tree", "Trouble", "lazy" } },
  },
}

return M
