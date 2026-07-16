---@type LazyPluginSpec
return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    highlight = {
      pattern = [[.*<(KEYWORDS).*:]],
    },
    search = {
      pattern = [[\b(KEYWORDS)(.*?):]],
    },
  },
}
