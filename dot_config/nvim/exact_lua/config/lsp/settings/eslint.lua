---@type lspconfig.options.eslint
local eslint = {
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
  settings = {
    eslint = {
      autoFixOnSave = true,
      format = { enable = true },
    },
  },
}

return eslint
