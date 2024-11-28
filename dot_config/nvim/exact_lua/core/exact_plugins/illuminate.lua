---@type LazyPluginSpec
local M = {
  "RRethy/vim-illuminate",
  event = "BufReadPost",
  enabled = false,
  opts = { delay = 200 },
  config = function(_, opts)
    local illuminate = require("illuminate")

    illuminate.configure(opts)

    require("core.util").on_attach(illuminate.on_attach)

    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        local buffer = vim.api.nvim_get_current_buf()
        pcall(vim.keymap.del, "n", "]]", { buffer = buffer })
        pcall(vim.keymap.del, "n", "[[", { buffer = buffer })
      end,
    })
  end,
  keys = {
    {
      "]]",
      function()
        require("illuminate").goto_next_reference(false)
      end,
      desc = "Next Reference",
    },
    {
      "[[",
      function()
        require("illuminate").goto_prev_reference(false)
      end,
      desc = "Prev Reference",
    },
  },
}

return M
