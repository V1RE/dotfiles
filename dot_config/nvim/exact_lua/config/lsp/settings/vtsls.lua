local util = require("lspconfig.util")

---@type lspconfig.options.vtsls
local tsserver = {
  root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
  single_file_support = false,
  settings = {
    vtsls = {
      javascript = {
        format = { enable = false },
        inlayHints = {
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
        inlayHints = {
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
  },
}

return tsserver
