---@type LazyPluginSpec[]
local M = {
  {
    "ahmedkhalf/project.nvim",
    ---@param opts ProjectOptions
    config = function(_, opts)
      require("project_nvim").setup(opts)
    end,
    ---@type ProjectOptions
    opts = {
      silent_chdir = true,
      manual_mode = true,
      detection_methods = { "pattern" },
    },
  },
}

return M
