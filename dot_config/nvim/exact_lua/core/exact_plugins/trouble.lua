---@type LazyPluginSpec
local M = {
  "folke/trouble.nvim",
  opts = {},
  keys = {
    { "<leader>xx", "<cmd>TroubleToggle<cr>", silent = true, noremap = true },
    { "<leader>xw", "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>", silent = true, noremap = true },
    { "<leader>xd", "<cmd>TroubleToggle lsp_document_diagnostics<cr>", silent = true, noremap = true },
    { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", silent = true, noremap = true },
    { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", silent = true, noremap = true },
    { "gR", "<cmd>TroubleToggle lsp_references<cr>", silent = true, noremap = true },
  },
}

return M
