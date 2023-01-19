local i = require("config.icons")

---@type LazyPluginSpec[]
local M = {
  {
    "cshuaimin/ssr.nvim",
    config = true,
    keys = {
      { "<leader>lR", require("ssr").open, desc = i.SearchCode .. "SSR" },
    },
  },
}

return M
