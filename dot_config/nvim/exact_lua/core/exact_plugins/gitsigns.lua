---@type LazyPluginSpec[]
local M = {
  {
    "lewis6991/gitsigns.nvim",
    ---@type Gitsigns.Config
    opts = {
      current_line_blame = true,
    },
  },
}

return M
