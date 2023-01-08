---@type LazyPluginSpec[]
local M = {
  {
    "ahmedkhalf/project.nvim",
    enabled = true,
    ---@type ProjectOptions
    opts = {
      silent_chdir = true,
    },
  },
}

return M
