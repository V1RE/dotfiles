local i = require("config.icons")

---@type LazyPluginSpec
local M = {
  "cshuaimin/ssr.nvim",
  config = true,
  keys = {
    {
      "<leader>lR",
      function()
        require("ssr").open()
      end,
      desc = i.SearchCode .. "SSR",
    },
  },
}

return M
