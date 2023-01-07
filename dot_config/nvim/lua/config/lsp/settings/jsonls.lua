local schemastore = require("schemastore")

--- @type lspconfig.options.jsonls
local jsonls = {
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {
      schemas = schemastore.json.schemas(),
    },
  },
}

return jsonls
