local i = require("config.icons")

---@type LazyPluginSpec[]
local M = {
  {
    "marilari88/twoslash-queries.nvim",
    config = function()
      local tsq = require("twoslash-queries")

      tsq.setup({})

      require("core.util").on_attach(tsq.attach)
    end,
    keys = {
      { "<leader>lq", "<cmd>InspectTwoslashQueries<cr>", desc = i.TypeParameter .. "Inspect type" },
      { "<leader>ld", "<cmd>RemoveTwoslashQueries<cr>", desc = i.Error .. "Remove type inspect" },
    },
  },
}

return M
