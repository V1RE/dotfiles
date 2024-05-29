---@type _.lspconfig.settings.vtsls.InlayHints
local inlayHints = {
  parameterNames = { enabled = "literals" },
  parameterTypes = { enabled = true },
  variableTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  enumMemberValues = { enabled = true },
}

---@type lspconfig.options.vtsls
local vtsls = {
  single_file_support = false,
  settings = {
    vtsls = {
      experimental = {
        enableProjectDiagnostics = true,
        useVsCodeWatcher = true,
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

return vtsls
