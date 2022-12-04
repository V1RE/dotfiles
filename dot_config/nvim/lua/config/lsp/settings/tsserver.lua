local util = require("lspconfig.util")

--- @type lspconfig.options.tsserver
local tsserver = {
  autostart = false,
  root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json"),
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
