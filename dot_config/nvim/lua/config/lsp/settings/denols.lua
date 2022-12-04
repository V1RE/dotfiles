local util = require("lspconfig.util")

--- @type lspconfig.options.denols
local denols = {
  root_dir = util.root_pattern("deno.json", "deno.jsonc"),
  settings = {
    deno = {
      inlayHints = {
        enumMemberValues = {
          enabled = true,
        },
        functionLikeReturnTypes = {
          enabled = true,
        },
        parameterNames = {
          enabled = "all",
        },
        parameterTypes = {
          enabled = true,
        },
        propertyDeclarationTypes = {
          enabled = true,
        },
        variableTypes = {
          enabled = true,
        },
      },
    },
  },
}

return denols
