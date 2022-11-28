--- @type lspconfig.options.sumneko_lua
local sumneko_lua = {
  settings = {
    Lua = {
      hint = {
        enable = true,
      },
      format = {
        enable = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

return sumneko_lua
