--- @type lspconfig.options.sumneko_lua
local sumneko_lua = {
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
      },
      hint = {
        enable = true,
        setType = true,
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
