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
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "◍",
          package_pending = "◍",
          package_uninstalled = "◍",
        },
      },
      log_level = vim.log.levels.INFO,
      max_concurrent_installers = 4,
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
        "tsgo",
      },
      automatic_enable = false,
    },
  },
}
