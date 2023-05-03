---@type LazyPluginSpec[]
local M = {
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>J", "<cmd>TSJToggle<cr>", desc = "Toggle SJ" },
    },
    opts = {
      use_default_keymaps = false,
    },
  },
}

return M
