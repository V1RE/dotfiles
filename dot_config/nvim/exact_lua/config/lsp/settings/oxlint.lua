---@type vim.lsp.Config
require('null-ls.formatting')
local oxlint = {
  root_markers = vim.tbl_extend("force", { "vite.config.ts" }, vim.lsp.config.oxlint.root_markers or {}),
}

return oxlint
