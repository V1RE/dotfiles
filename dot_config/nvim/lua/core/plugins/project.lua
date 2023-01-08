---@type LazyPluginSpec[]
local M = {
  {
    "ahmedkhalf/project.nvim",
    ---@type ProjectOptions
    opts = {
      silent_chdir = true,
      detection_methods = { "pattern" },
    },
  },
}

return M
