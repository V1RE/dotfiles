---@type LazyPluginSpec[]
local M = {
  {
    "echasnovski/mini.hipatterns",
    config = function(_, opts)
      require("mini.hipatterns").setup(opts)
    end,
  },
}

return M
