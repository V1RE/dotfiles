local schemastore = require("schemastore")

---@type lspconfig.options.jsonls
local jsonls = {
  init_options = {
    provideFormatter = false,
  },
  settings = {
    json = {
      schemas = schemastore.json.schemas({
        extra = {
          {
            url = "https://unpkg.com/syncpack/dist/schema.json",
            fileMatch = { ".syncpackrc.json" },
            name = "Syncpack",
            description = "Consistent dependency versions in large JavaScript Monorepos",
          },
        },
      }),
    },
  },
}

return jsonls
