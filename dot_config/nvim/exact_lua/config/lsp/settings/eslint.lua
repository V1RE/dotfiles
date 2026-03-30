---@type vim.lsp.Config
local eslint = {
  ---@type lspconfig.settings.eslint
  settings = {
    eslint = {
      format = { enable = true },
    },
  },
}

return eslint
