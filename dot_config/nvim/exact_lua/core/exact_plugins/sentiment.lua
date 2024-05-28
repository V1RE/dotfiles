---@type LazyPluginSpec[]
local M = {
  {
    "utilyre/sentiment.nvim",
    version = "*",
    event = "VeryLazy", -- keep for lazy loading
    opts = {
      -- config
    },
    -- init = function()
    --   vim.g.loaded_matchparen = 1
    -- end,
    enabled = false,
  },
}

return M
