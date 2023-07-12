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
    ft = { "typescript", "typescriptreact" },
    keys = {
      { "<leader>lq", "<cmd>InspectTwoslashQueries<cr>", desc = i.TypeParameter .. "Inspect type" },
      { "<leader>ld", "<cmd>RemoveTwoslashQueries<cr>", desc = i.Error .. "Remove type inspect" },
    },
  },

  {
    "dmmulroy/tsc.nvim",
    config = function()
      require("tsc").setup({
        flags = {
          build = true,
        },
      })
    end,
  },

  ---@type LazyPluginSpec
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
    branch = "feat-commands-as-code-actions",
  },
}

return M
