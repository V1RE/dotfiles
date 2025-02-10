---@type LazyPluginSpec
return {
  "folke/todo-comments.nvim",
  opts = {
    highlight = {
      pattern = [[.*<(KEYWORDS).*:]],
    },
    search = {
      pattern = [[\b(KEYWORDS)(.*?):]],
    },
  },
  enabled = true,
}
