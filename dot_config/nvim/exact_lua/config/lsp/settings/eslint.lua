---@type lspconfig.options.eslint
local eslint = {
  settings = {
    eslint = {
      autoFixOnSave = true,
      format = { enable = true },
    },
  },
}

return eslint
