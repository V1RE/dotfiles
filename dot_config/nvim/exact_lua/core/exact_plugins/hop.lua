---@type LazyPluginSpec[]
local M = {
  {
    "smoka7/hop.nvim",
    version = "*",
    opts = {
      keys = "etovxqpdygfblzhckisuran",
    },
    keys = {
      { "<Tab>", ":HopWord<CR>", mode = "n", desc = "Hop to word", noremap = true },
    },
  },
}

return M
