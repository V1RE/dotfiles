---@type LazyPluginSpec[]
local M = {
  {
    "echasnovski/mini.surround",
    keys = { "s" },
    config = function(_, opts)
      require("mini.surround").setup(opts)
    end,
  },
}

return M
