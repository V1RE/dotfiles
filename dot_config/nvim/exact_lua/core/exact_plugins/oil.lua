local i = require("config.icons")

---@type LazyPluginSpec
local M = {
  "stevearc/oil.nvim",
  ---@type oil.setupOpts
  opts = {
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
  },
  lazy = false,
  keys = {
    { "<leader>e", "<cmd>Oil<cr>", desc = i.NeoTree .. "Show Oil" },
  },
}

return M
