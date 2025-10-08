---@type LazyPluginSpec[]
return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
  },

  -- Mason package manager
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {},
  },

  -- Mason LSP configuration
  {
    "mason-org/mason-lspconfig.nvim",
    version = "^1.0.0",
    dependencies = {
      "mason.nvim",
      "nvim-lspconfig",
    },
    opts = {},
  },
}
