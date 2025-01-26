---@type LazyPluginSpec[]
local M = {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      lazygit = {},
    },
    keys = {
      {
        "<leader>gg",
        function()
          require("snacks").lazygit.open()
        end,
        desc = "Lazygit (cwd)",
      },
    },
  },
}

return M
