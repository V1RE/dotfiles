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
        nodePath = "~/.local/share/mise/installs/node/latest/bin/node --max-old-space-size=8192",
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
        nodePath = "~/.local/share/mise/installs/node/latest/bin/node --max-old-space-size=8192",
      },
      referencesCodeLens = {
        showOnAllFunctions = true,
        enabled = true,
      },
    },
  },
}

return vtsls
