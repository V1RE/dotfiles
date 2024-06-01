---@type lspconfig.options.volar
local volar = {
  filetypes = { "vue" },
  init_options = {
    vue = {
      hybridMode = false,
    },
  },
}

return volar
