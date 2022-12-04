local util = require("lspconfig.util")

--- @type lspconfig.options.tsserver
local tsserver = {
  root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
  settings = {
    typescript = {
      inlayHints = {
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
        parameterNames = { enabled = "all" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = true },
      },
      format = { enable = false },
      referencesCodeLens = { enabled = true },
    },
  },
}

return tsserver
