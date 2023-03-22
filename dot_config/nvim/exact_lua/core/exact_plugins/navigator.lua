---@type LazyPluginSpec
local M = {
  "numToStr/Navigator.nvim",
  event = "VeryLazy",
  config = true,
  keys = {
    { "<c-h>", "<CMD>NavigatorLeft<CR>", mode = { "n", "t" } },
    { "<c-l>", "<CMD>NavigatorRight<CR>", mode = { "n", "t" } },
    { "<c-k>", "<CMD>NavigatorUp<CR>", mode = { "n", "t" } },
    { "<c-j>", "<CMD>NavigatorDown<CR>", mode = { "n", "t" } },
    { "<c-p>", "<CMD>NavigatorPrevious<CR>", mode = { "n", "t" } },
  },
}

return M
