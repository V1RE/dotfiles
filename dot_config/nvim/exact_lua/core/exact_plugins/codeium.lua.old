---@type LazyPluginSpec[]
local M = {
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = true,
  },
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        disable_keymaps = true,
        disable_inline_completion = true,
      })
    end,
  },
}

return M
