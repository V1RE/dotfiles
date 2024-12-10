---@type lspconfig.options.vtsls
local vtsls = {
  single_file_support = false,
  settings = {
    vtsls = {
      experimental = {
        enableProjectDiagnostics = true,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      tsserver = {
        maxTsServerMemory = 8192,
        nodePath = "~/.local/share/mise/installs/node/latest/bin/node",
      },
    },
    javascript = {
      format = { enable = false },
    },
    typescript = {
      format = { enable = false },
      implementationsCodeLens = {
        enabled = true,
        showOnInterfaceMethods = true,
      },
      preferences = {
        useAliasesForRenames = true,
        preferTypeOnlyAutoImports = true,
      },
      tsserver = {
        maxTsServerMemory = 8192,
        nodePath = "~/.local/share/mise/installs/node/latest/bin/node",
      },
      referencesCodeLens = {
        showOnAllFunctions = true,
        enabled = true,
      },
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

return vtsls
