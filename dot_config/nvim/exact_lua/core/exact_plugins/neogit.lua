---@type LazyPluginSpec
local M = {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = true,
  cmd = "Neogit",
  keys = {
    {
      "<leader>gg",
      function()
        require("neogit").open()
      end,
      desc = "Neogit",
    },
  },
}

return M
