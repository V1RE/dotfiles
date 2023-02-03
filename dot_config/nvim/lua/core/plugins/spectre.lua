---@type LazyPluginSpec
local M = {
  "windwp/nvim-spectre",
  keys = {
    {
      "<leader>cr",
      function()
        require("spectre").open()
      end,
      desc = "Replace in files (Spectre)",
    },
  },
}

return M
