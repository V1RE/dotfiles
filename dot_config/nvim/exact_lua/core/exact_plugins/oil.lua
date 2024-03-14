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
  },
  init = function()
    if vim.fn.argc(-1) == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      if stat and stat.type == "directory" then
        require("oil").open()
      end
    end
  end,
}

return M
