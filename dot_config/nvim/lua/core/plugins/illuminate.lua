---@type LazyPluginSpec
local M = {
  "RRethy/vim-illuminate",
  event = "BufReadPost",
  config = function()
    require("illuminate").configure({
      providers = {
        "lsp",
        "treesitter",
      },
      delay = 100,
      filetypes_denylist = {
        "neo-tree",
      },
      under_cursor = false,
    })
  end,
}

return M
