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

---@type _.lspconfig.options
local opts = {
  on_attach = require("config.lsp.handlers").on_attach,
  capabilities = require("config.lsp.handlers").capabilities,
}

---@param server string
local function merge_options(server)
  local server_options = require("config.lsp.settings." .. server) or {}

  return vim.tbl_deep_extend("keep", server_options, opts)
end

mason_lspconfig.setup_handlers({
  function(server)
    lspconfig[server].setup(opts)
  end,

  ["sumneko_lua"] = function(server)
    lspconfig.sumneko_lua.setup(merge_options(server))
  end,

  ["jsonls"] = function(server)
    lspconfig.jsonls.setup(merge_options(server))
  end,

  ["yamlls"] = function(server)
    lspconfig.yamlls.setup(merge_options(server))
  end,

  --[[ ["denols"] = function(server)
    lspconfig.denols.setup(merge_options(server))
  end, ]]

  ["tsserver"] = function(server)
    require("typescript").setup({ server = merge_options(server) })
  end,
})
