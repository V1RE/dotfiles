local util = require("lspconfig.util")

--- @type lspconfig.settings.denols
local denols = {
  root_dir = util.root_pattern("deno.json"),
}

return denols
