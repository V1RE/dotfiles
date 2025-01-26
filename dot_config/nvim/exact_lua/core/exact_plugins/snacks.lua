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
      dashboard = {
        enabled = true,
        preset = "github",
      },
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" }, -- priority of signs on the left (high to low)
        right = { "fold", "git" }, -- priority of signs on the right (high to low)
      },
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
      {
        "gn",
        function()
          require("snacks").words.jump(1, true)
        end,
        desc = "Go to next word",
      },
      {
        "gp",
        function()
          require("snacks").words.jump(-1, true)
        end,
        desc = "Go to previous word",
      },
    },
  },
}

return M
