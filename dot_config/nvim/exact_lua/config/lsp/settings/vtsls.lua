---@type _.lspconfig.settings.vtsls.InlayHints
local inlayHints = {
  parameterNames = { enabled = "all" },
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
      inlayHints,
    },
    typescript = {
      format = { enable = false },
      implementationsCodeLens = {
        enabled = true,
        showOnInterfaceMethods = true,
      },
      inlayHints,
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
    },
  },
}

return vtsls
