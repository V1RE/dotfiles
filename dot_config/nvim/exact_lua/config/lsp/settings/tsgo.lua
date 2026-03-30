---@type vim.lsp.Config
local tsls = {
  single_file_support = false,
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },

  ---@type lspconfig.settings.ts_ls
  settings = {
    typescript = {
      experimental = {
        useTsgo = true,
      },

      autoClosingTags = true,
      check = { npmIsInstalled = true },
      disableAutomaticTypeAcquisition = false,
      enablePromptUseWorkspaceTsdk = true,
      implementationsCodeLens = {
        enabled = true,
        showOnAllClassMethods = true,
        showOnInterfaceMethods = true,
      },
      suggestionActions = {
        enabled = true,
      },
      preferGoToSourceDefinition = true,
      reportStyleChecksAsWarnings = false,
      tsc = {},
      suggest = {
        completeFunctionCalls = true,
        autoImports = true,
        completeJSDocs = true,
        classMemberSnippets = {
          enabled = true,
        },
        enabled = true,
        jsdoc = { generateReturns = true },
        includeAutomaticOptionalChainCompletions = true,
        includeCompletionsForImportStatements = true,
        objectLiteralMethodSnippets = { enabled = true },
        paths = true,
      },
      preferences = {
        useAliasesForRenames = true,
        preferTypeOnlyAutoImports = true,
      },
      tsserver = {
        maxTsServerMemory = 8192,
        experimental = {
          enableProjectDiagnostics = true,
        },
      },
      referencesCodeLens = {
        showOnAllFunctions = true,
        enabled = true,
      },
      workspaceSymbols = {
        excludeLibrarySymbols = true,
        scope = "allOpenProjects",
      },
      updateImportsOnFileMove = { enabled = "always" },
      format = { enable = false },
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
}

tsls.settings.javascript = vim.tbl_deep_extend("force", {}, tsls.settings.typescript, tsls.settings.javascript or {})

return tsls
