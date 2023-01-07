local util = require("lspconfig.util")

--- @type lspconfig.options.denols
local denols = {
  root_dir = util.root_pattern("deno.json", "deno.jsonc"),
}

return denols
