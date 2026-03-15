---@type LazyPluginSpec
return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {},
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    { "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace Diagnostics (Trouble)" },
    { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    { "gR", "<cmd>Trouble lsp_references toggle focus=false win.position=right<cr>", desc = "References (Trouble)" },
  },
}
