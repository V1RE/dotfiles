local base_on_attach = vim.lsp.config.eslint.on_attach

---@type vim.lsp.Config
local eslint = {
  on_attach = function(client, bufnr)
    if not base_on_attach then
      return
    end

    base_on_attach(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "LspEslintFixAll",
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
