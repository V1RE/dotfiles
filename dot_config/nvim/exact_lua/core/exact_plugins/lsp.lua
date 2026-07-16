---@type LazyPluginSpec[]
return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-lspconfig.nvim",
      "saghen/blink.cmp",
      "neoconf.nvim",
    },
  },

  -- Mason package manager
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },

  -- Mason LSP configuration
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "eslint",
        "jsonls",
        "lua_ls",
        "yamlls",
        "oxlint",
        "vtsls",
      },
      automatic_enable = false,
    },
  },
}
