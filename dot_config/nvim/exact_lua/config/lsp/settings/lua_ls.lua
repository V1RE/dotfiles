---@type lspconfig.options.lua_ls
local lua_ls = {
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
      },
      hint = {
        enable = true,
        setType = true,
        arrayIndex = "Disable",
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

return lua_ls
