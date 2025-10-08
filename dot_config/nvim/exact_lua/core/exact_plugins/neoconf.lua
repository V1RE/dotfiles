---@type LazyPluginSpec
return {
  "folke/neoconf.nvim",
  config = true,
  lazy = false,
  priority = 1000, -- Must load before LSP
}
