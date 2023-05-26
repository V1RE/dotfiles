local util = require("lspconfig.util")

---@type lspconfig.options.tsserver
local tsserver = {
  root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
  settings = {
    javascript = {
      format = { enable = false },
      inlayHints = {
        variableTypes = { enabled = true },
        parameterTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = false },
        parameterNames = { enabled = "all" },
        enumMemberValues = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    typescript = {
      format = { enable = false },
      implementationsCodeLens = { enabled = true },
      preferGoToSourceDefinition = true,
      inlayHints = {
        variableTypes = { enabled = true },
        parameterTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = false },
        parameterNames = { enabled = "all" },
        enumMemberValues = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
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
}

return tsserver
