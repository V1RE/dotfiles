---@type lspconfig.options.vtsls
local vtsls = {
  single_file_support = false,
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  settings = {
    complete_function_calls = true,
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
        nodePath = "~/.local/share/mise/installs/node/latest/bin/node",
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
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
        nodePath = "~/.local/share/mise/installs/node/latest/bin/node",
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
