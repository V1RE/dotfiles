---@type LazyPluginSpec[]
local M = {
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
      tailwind = true, -- Enable tailwind colors
    },
  },
}

return M
