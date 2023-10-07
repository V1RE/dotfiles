local util = require("lspconfig.util")

---@type _.lspconfig.settings.vtsls.InlayHints
local inlayHints = {
  enumMemberValues = { enabled = true },
  variableTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  parameterTypes = { enabled = true },
  parameterNames = { enabled = "all" },
}

---@type lspconfig.options.vtsls
local tsserver = {
  root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
  single_file_support = false,
  settings = {
    vtsls = {
      experimental = {
        enableProjectDiagnostics = true,
        completion = { enableServerSideFuzzyMatch = true, entriesLimit = 25 },
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
        importModuleSpecifier = "non-relative",
      },
      tsserver = {
        maxTsServerMemory = 8192,
      },
      referencesCodeLens = {
        showOnAllFunctions = true,
        enabled = true,
      },
      tsdk = "node_modules/typescript/lib",
    },
  },
}

return tsserver
