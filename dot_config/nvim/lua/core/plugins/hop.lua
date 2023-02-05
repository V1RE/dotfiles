---@type LazyPluginSpec
local M = {
  "phaazon/hop.nvim",
  config = true,
  keys = {
    {
      "f",
      function()
        require("hop").hint_char2()
      end,
      remap = true,
      desc = "Hop to char",
      mode = { "n", "v" },
    },
  },
}

return M
