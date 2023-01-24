---@type LazyPluginSpec[]
local M = {
  {
    "marilari88/twoslash-queries.nvim",
    config = function()
      local tsq = require("twoslash-queries")

      tsq.setup()

      require("core.util").on_attach(tsq.attach)
    end,
    ft = { "typescript", "typescriptreact" },
  },
}

return M
