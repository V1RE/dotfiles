---@type LazyPluginSpec
local M = {
  "rcarriga/nvim-notify",
  enabled = false,
  keys = {
    {
      "<leader>nd",
      function()
        require("notify").dismiss({ silent = true, pending = true })
      end,
      desc = "Delete all Notifications",
    },
  },
  ---@type notify.Config
  opts = {
    timeout = 3000,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
  },
}

return M
