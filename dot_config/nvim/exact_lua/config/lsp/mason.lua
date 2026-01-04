local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

-- Configure vtsls custom config
-- vim.lsp.config("vtsls", require("vtsls").lspconfig)

mason.setup({
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
})

---@class _.lspconfig.options
local opts = {
  capabilities = require("config.lsp.handlers").capabilities,
}

---@param server string
local function merge_options(server)
  local server_options = require("config.lsp.settings." .. server) or {}

  return vim.tbl_deep_extend("keep", server_options, opts)
end

-- Configure individual servers
vim.lsp.config("kotlin_language_server", {})

vim.lsp.config("sourcekit", merge_options("sourcekit"))

-- Setup mason-lspconfig handlers
mason_lspconfig.setup_handlers({
  function(server)
    vim.lsp.config(server, opts)
    vim.lsp.enable(server)
  end,

  ["lua_ls"] = function(server)
    vim.lsp.config("lua_ls", merge_options(server))
    vim.lsp.enable("lua_ls")
  end,

  ["jsonls"] = function(server)
    vim.lsp.config("jsonls", merge_options(server))
    vim.lsp.enable("jsonls")
  end,

  ["yamlls"] = function(server)
    vim.lsp.config("yamlls", merge_options(server))
    vim.lsp.enable("yamlls")
  end,

  -- ["vtsls"] = function(server)
  --   vim.lsp.config('vtsls', merge_options(server))
  --   vim.lsp.enable('vtsls')
  -- end,

  ["ts_ls"] = function(server)
    vim.lsp.config("ts_ls", merge_options(server))
    vim.lsp.enable("ts_ls")
  end,

  ["stylelint_lsp"] = function(server)
    vim.lsp.config("stylelint_lsp", merge_options(server))
    vim.lsp.enable("stylelint_lsp")
  end,

  ["eslint"] = function(server)
    vim.lsp.config("eslint", merge_options(server))
    vim.lsp.enable("eslint")
  end,
})
