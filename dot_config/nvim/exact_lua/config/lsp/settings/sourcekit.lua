---@type lspconfig.options.sourcekit
local sourcekit = {
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
  settings = {
    ["sourcekit-lsp"] = {},
    swift = {},
  },
}

return sourcekit
