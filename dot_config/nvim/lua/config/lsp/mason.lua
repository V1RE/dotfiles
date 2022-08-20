local mason_ok = pcall(require, "mason")
local mason_lsp_ok = pcall(require, "mason-lspconfig")
local lsp_ok = pcall(require, "lspconfig")

if not mason_ok and mason_lsp_ok and lsp_ok then
  return
end

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

local settings = {
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
}

mason.setup(settings)
mason_lspconfig.setup()

for _, server in pairs(mason_lspconfig.get_installed_servers()) do
  local opts = {
    on_attach = require("config.lsp.handlers").on_attach,
    capabilities = require("config.lsp.handlers").capabilities,
  }

  server = vim.split(server, "@")[1]

  if server == "jsonls" then
    local jsonls_opts = require("config.lsp.settings.jsonls")
    opts = vim.tbl_deep_extend("force", jsonls_opts, opts) or {}
  end

  if server == "yamlls" then
    local yamlls_opts = require("config.lsp.settings.yamlls")
    opts = vim.tbl_deep_extend("force", yamlls_opts, opts) or {}
  end

  if server == "sumneko_lua" then
    local sumneko_lua_opts = require("config.lsp.settings.sumneko_lua")
    opts = vim.tbl_deep_extend("force", sumneko_lua_opts, opts) or {}
    opts = require("lua-dev").setup({ lspconfig = opts }) or {}
  end

  if server == "tsserver" then
    local tsserver_opts = require("config.lsp.settings.tsserver")
    opts = vim.tbl_deep_extend("force", tsserver_opts, opts) or {}
    require("typescript").setup({ server = opts })
  end

  lspconfig[server].setup(opts)
end
