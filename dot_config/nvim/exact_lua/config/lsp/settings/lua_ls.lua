---@type lspconfig.options.lua_ls
local lua_ls = {
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
      },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = "Disable",
        semicolon = "Disable",
        arrayIndex = "Disable",
      },
      format = {
        enable = false,
      },
      telemetry = {
        enable = false,
      },
      codeLens = {
        enable = true,
      },
      completion = {
        callSnippet = "Replace",
      },
      doc = {
        privateName = { "^_" },
      },
    },
  },
}

return lua_ls
