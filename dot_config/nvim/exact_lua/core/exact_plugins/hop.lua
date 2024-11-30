---@type LazyPluginSpec[]
local M = {
  {
    "smoka7/hop.nvim",
    version = "*",
    opts = {
      keys = "etovxqpdygfblzhckisuran",
    },
    keys = {
      {
        "<C-Space>",
        function()
          require("hop").hint_words({})
        end,
        mode = "n",
        desc = "Hop to word",
        noremap = true,
      },
    },
  },
}

return M
