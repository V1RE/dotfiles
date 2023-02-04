local i = require("config.icons")

---@type LazyPluginSpec[]
local M = {
  {
    "marilari88/twoslash-queries.nvim",
    init = function()
      local tsq = require("twoslash-queries")

      tsq.setup({})

      require("core.util").on_attach(tsq.attach)
    end,
    keys = {
      { "<leader>lq", "<cmd>InspectTwoslashQueries<cr>", desc = i.TypeParameter .. "Inspect type" },
      { "<leader>ld", "<cmd>RemoveTwoslashQueries<cr>", desc = i.Error .. "Remove type inspect" },
    },
  },

  {
    "jose-elias-alvarez/typescript.nvim",
    config = function()
      require("core.util").on_attach(function(client, buffer)
        if client.name ~= "tsserver" then
          vim.keymap.set(
            "n",
            "<leader>lt",
            "<cmd>TypescriptRemoveUnused<cr>",
            { desc = i.Module .. "Remove unused imports", buffer = buffer }
          )
        end
      end)
    end,
  },
}

return M
