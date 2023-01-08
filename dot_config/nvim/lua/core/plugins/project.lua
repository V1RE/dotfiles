---@type LazyPluginSpec[]
local M = {
  {
    "ahmedkhalf/project.nvim",
    enabled = false,
    ---@type ProjectOptions
    opts = {
      silent_chdir = true,
    },
  },
}

return M
