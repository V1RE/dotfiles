local util = require("lspconfig.util")

---@type vim.lsp.Config
local denols = {
  root_dir = util.root_pattern("deno.json", "deno.jsonc"),

  ---@type lspconfig.settings.denols
  settings = {
    deno = {
      enable = false,
    },
  },
}

return denols
