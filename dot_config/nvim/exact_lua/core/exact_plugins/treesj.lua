---@type LazyPluginSpec[]
local M = {
  {
    "Wansmer/treesj",
    keys = {
      {
        "<leader>J",
        "<cmd>TSToggle<cr>",
        desc = "Toggle SJ",
      },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      use_default_keymaps = false,
    },
  },
}

return M
