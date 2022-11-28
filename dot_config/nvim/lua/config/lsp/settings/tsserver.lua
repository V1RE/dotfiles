--- @type lspconfig.options.tsserver
local tsserver = {
  settings = {
    typescript = {
      inlayHints = {
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
        parameterNames = { enabled = "all" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = true },
      },
      format = { enable = false },
      referencesCodeLens = { enabled = true },
    },
  },
}

return tsserver
