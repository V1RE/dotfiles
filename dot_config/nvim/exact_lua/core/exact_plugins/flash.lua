---@type LazyPluginSpec
local M = {
  "folke/flash.nvim",
  event = "VeryLazy",
  enabled = false,
  ---@type Flash.Config
  opts = {},
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        -- default options: exact mode, multi window, all directions, with a backdrop
        require("flash").jump()
      end,
    },
    {
      "S",
      mode = { "o", "x" },
      function()
        require("flash").treesitter()
      end,
    },
  },
}

return M
