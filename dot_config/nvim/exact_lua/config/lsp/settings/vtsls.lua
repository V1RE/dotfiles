---@type vim.lsp.Config
local vtsls = {
  single_file_support = false,
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },

  -- Only keep code actions; tsgo handles everything else
  on_attach = function(client)
    client.server_capabilities.completionProvider = nil
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.referencesProvider = false
    client.server_capabilities.renameProvider = false
    client.server_capabilities.signatureHelpProvider = nil
    client.server_capabilities.implementationProvider = false
    client.server_capabilities.typeDefinitionProvider = false
    client.server_capabilities.documentHighlightProvider = false
    client.server_capabilities.documentSymbolProvider = false
    client.server_capabilities.workspaceSymbolProvider = false
    client.server_capabilities.declarationProvider = false
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.inlayHintProvider = nil
    client.server_capabilities.codeLensProvider = nil
    client.server_capabilities.diagnosticProvider = nil
    client.server_capabilities.semanticTokensProvider = nil
  end,

  ---@type lspconfig.settings.vtsls
  settings = {
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
      tsserver = {
        maxTsServerMemory = 8192,
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      implementationsCodeLens = { enabled = true, showOnAllClassMethods = true, showOnInterfaceMethods = true },
      suggest = {
        completeFunctionCalls = true,
      },
      format = { enable = false },
      preferences = {
        useAliasesForRenames = true,
        preferTypeOnlyAutoImports = true,
      },
      tsserver = {
        maxTsServerMemory = 8192,
      },
      referencesCodeLens = {
        showOnAllFunctions = true,
        enabled = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
  },
}

vtsls.settings.javascript = vim.tbl_deep_extend("force", {}, vtsls.settings.typescript, vtsls.settings.javascript or {})

return vtsls
