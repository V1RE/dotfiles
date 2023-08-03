---@type LazyPluginSpec
local M = {
  "folke/todo-comments.nvim",
  opts = {
    highlight = {
      pattern = [[.*<(KEYWORDS).*:]],
    },
    search = {
      pattern = [[\b(KEYWORDS)(.*?):]],
    },
  },
}

return M
