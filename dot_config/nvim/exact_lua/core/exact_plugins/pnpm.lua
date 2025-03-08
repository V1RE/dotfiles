---@type LazyPluginSpec[]
return {
  {
    "ryoppippi/nvim-pnpm-catalog-lens",
    lazy = false,
    init = function()
      vim.g.pnpm_catalog_display = "overlay"
    end,
  },
}
