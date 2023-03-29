---@type lspconfig.options.stylelint_lsp
local stylelint_lsp = {
  settings = {
    stylelintplus = {
      autoFixOnFormat = true,
      autoFixOnSave = true,
      cssInJs = false,
    },
  },
}

return stylelint_lsp
