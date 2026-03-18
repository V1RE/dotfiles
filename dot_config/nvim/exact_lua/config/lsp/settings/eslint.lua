---@type vim.lsp.Config
local eslint = {
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,

  ---@type lspconfig.settings.eslint
  settings = {
    eslint = {
      autoFixOnSave = true,
      format = { enable = true },
    },
  },
}

return eslint
