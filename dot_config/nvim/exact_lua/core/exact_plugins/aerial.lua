---@type LazyPluginSpec
return {
  "stevearc/aerial.nvim",
  event = "VeryLazy",
  opts = {
    attach_mode = "global",
    backends = { "lsp", "treesitter", "markdown" },
    show_guides = true,
    icons = require("config.icons"),
    filter_kind = false,
    close_on_select = true,
    layout = { default_direction = "float" },
  },
}
