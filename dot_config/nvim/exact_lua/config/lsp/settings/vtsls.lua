---@type lspconfig.options.vtsls
local tsserver = {
  settings = {
    vtsls = {
      javascript = { format = { enable = false } },
      typescript = {
        format = { enable = false },
        implementationsCodeLens = { enabled = true },
        inlayHints = {
          enumMemberValues = { enabled = true },
          parameterNames = { enabled = "all" },
          functionLikeReturnTypes = { enabled = true },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = true },
        },
        preferences = {
          useAliasesForRenames = false,
          importModuleSpecifier = "non-relative",
        },
        experimental = {
          enableProjectDiagnostics = true,
          completion = { enableServerSideFuzzyMatch = true, entriesLimit = 25 },
          tsserver = { maxTsServerMemory = 4096 },
        },
      },
    },
  },
}

return tsserver
