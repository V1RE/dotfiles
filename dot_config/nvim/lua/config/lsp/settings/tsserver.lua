local util = require("lspconfig.util")

--- @type lspconfig.options.tsserver
local tsserver = {
  autostart = util.find_package_json_ancestor(".") ~= nil,
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
