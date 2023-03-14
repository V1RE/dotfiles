---@type lspconfig.options.yamlls
local yamlls = {
  settings = {
    yaml = {
      validate = true,
    },
    redhat = {
      telemetry = {
        enabled = false,
      },
    },
  },
}

return yamlls
