local util = require("lspconfig.util")

---@type lspconfig.options.vtsls
local tsserver = {
  root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
  single_file_support = false,
  settings = {
    vtsls = {
      javascript = { format = { enable = false } },
      typescript = {
        format = { enable = false },
        implementationsCodeLens = { enabled = true },
        inlayHints = {
          enumMemberValues = { enabled = true },
          parameterNames = { enabled = "all" },
          functionLikeReturnTypes = { enabled = true },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = true },
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
