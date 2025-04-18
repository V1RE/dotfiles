local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
lspconfig.kotlin_language_server.setup({})

require("lspconfig.configs").vtsls = require("vtsls").lspconfig

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

-- lspconfig.gopls.setup(opts)
lspconfig.sourcekit.setup(merge_options("sourcekit"))

mason_lspconfig.setup_handlers({
  function(server)
    lspconfig[server].setup(opts)
  end,

  ["lua_ls"] = function(server)
    lspconfig.lua_ls.setup(merge_options(server))
  end,

  ["jsonls"] = function(server)
    lspconfig.jsonls.setup(merge_options(server))
  end,

  ["yamlls"] = function(server)
    lspconfig.yamlls.setup(merge_options(server))
  end,

  -- ["denols"] = function(server)
  --   lspconfig.denols.setup(merge_options(server))
  -- end,

  ["vtsls"] = function(server)
    lspconfig.vtsls.setup(merge_options(server))
  end,

  -- ["ts_ls"] = function(server)
  --   lspconfig.ts_ls.setup(merge_options(server))
  -- end,

  -- ["volar"] = function(server)
  --   lspconfig.volar.setup(merge_options(server))
  -- end,

  ["stylelint_lsp"] = function(server)
    lspconfig.stylelint_lsp.setup(merge_options(server))
  end,

  ["eslint"] = function(server)
    lspconfig.eslint.setup(merge_options(server))
  end,
})
