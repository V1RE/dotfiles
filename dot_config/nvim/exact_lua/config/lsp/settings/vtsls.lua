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
  root_dir = function(filename)
    return util.find_git_ancestor(filename)
      or util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")(filename)
  end,
  single_file_support = false,
  settings = {
    vtsls = {
      experimental = {
        enableProjectDiagnostics = true,
        completion = { enableServerSideFuzzyMatch = true, entriesLimit = 25 },
      },
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
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
        preferTypeOnlyAutoImports = true,
      },
      tsserver = {
        maxTsServerMemory = 8192,
        nodePath = "/Users/niels/.local/share/mise/installs/bun/latest/bin/bun",
      },
      referencesCodeLens = {
        showOnAllFunctions = true,
        enabled = true,
      },
      experimental = {
        aiCodeActions = {
          extractInterface = true,
          missingFunctionDeclaration = true,
          extractType = true,
          inferAndAddTypes = true,
          extractFunction = true,
          extractConstant = true,
          classIncorrectlyImplementsInterface = true,
          classDoesntImplementInheritedAbstractMember = true,
          addNameToNamelessParameter = true,
        },
        enableProjectDiagnostics = true,
      },
    },
  },
}

return tsserver
