---@type LazyPluginSpec
local M = {
  "folke/todo-comments.nvim",
  opts = {
    highlight = {
      pattern = [[.*<(KEYWORDS).*:]],
    },
  },
}

return M
