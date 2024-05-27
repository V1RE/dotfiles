---@type _.lspconfig.settings.vtsls.InlayHints
local inlayHints = {
  enumMemberValues = { enabled = true },
  variableTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  parameterTypes = { enabled = true },
  parameterNames = { enabled = "all" },
}

---@type lspconfig.options.vtsls
local tsserver = {
  single_file_support = false,
  settings = {
    vtsls = {
      experimental = {
        enableProjectDiagnostics = true,
        completion = { enableServerSideFuzzyMatch = true, entriesLimit = 25 },
      },
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      tsserver = {
        globalPlugins = {},
      },
    },
    javascript = {
      format = { enable = false },
      inlayHints,
    },
    typescript = {
      format = { enable = false },
      implementationsCodeLens = { enabled = true },
      inlayHints,
      preferences = {
        useAliasesForRenames = false,
        preferTypeOnlyAutoImports = true,
      },
      tsserver = {
        maxTsServerMemory = 8192,
      },
      referencesCodeLens = {
        showOnAllFunctions = true,
        enabled = true,
      },
      experimental = {
        aiCodeActions = {
          missingFunctionDeclaration = true,
          extractType = true,
          inferAndAddTypes = true,
          extractFunction = true,
          extractConstant = true,
          classIncorrectlyImplementsInterface = true,
          classDoesntImplementInheritedAbstractMember = true,
          addNameToNamelessParameter = true,
        },
        enableProjectDiagnostics = true,
      },
    },
  },
}

return tsserver
