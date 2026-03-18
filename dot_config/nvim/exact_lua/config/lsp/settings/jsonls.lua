local schemastore = require("schemastore")

---@type vim.lsp.Config
local jsonls = {
  init_options = {
    provideFormatter = false,
  },
  ---@type lspconfig.settings.jsonls
  settings = {
    json = {
      schemas = schemastore.json.schemas(),
    },
  },
}

return jsonls
