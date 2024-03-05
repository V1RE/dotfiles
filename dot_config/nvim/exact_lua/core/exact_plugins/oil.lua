local i = require("config.icons")

---@type LazyPluginSpec
local M = {
  "stevearc/oil.nvim",
  opts = {
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
  },
  keys = {
    { "<leader>e", "<cmd>Oil<cr>", desc = i.NeoTree .. "Show Oil" },
    -- { "<leader>E", "<cmd>Neotree toggle<cr>", desc = i.NeoTree .. "Toggle tree" },
  },
}

return M
