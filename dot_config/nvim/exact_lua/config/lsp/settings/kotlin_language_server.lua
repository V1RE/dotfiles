---@type lspconfig.options.kotlin_language_server
local kotlin_language_server = {
  filetypes = { "kotlin", "kt", "kts" },
  settings = {
    kotlin = {},
  },
}

return kotlin_language_server
