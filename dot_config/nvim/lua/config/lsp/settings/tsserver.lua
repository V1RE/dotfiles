local util = require("lspconfig.util")

--- @type lspconfig.options.tsserver
local tsserver = {
  root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
  settings = {
    typescript = {
      format = { enable = false },
    },
  },
}

return tsserver
