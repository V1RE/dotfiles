local schemastore = require("schemastore")

---@type lspconfig.options.jsonls
local jsonls = {
  init_options = {
    provideFormatter = false,
  },
  settings = {
    json = {
      schemas = schemastore.json.schemas(),
    },
  },
}

return jsonls
