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

local opts = {
  on_attach = require("config.lsp.handlers").on_attach,
  capabilities = require("config.lsp.handlers").capabilities,
}

mason_lspconfig.setup_handlers({
  function(server)
    lspconfig[server].setup(opts)
  end,

  ["sumneko_lua"] = function()
    lspconfig.sumneko_lua.setup(vim.tbl_deep_extend("force", require("config.lsp.settings.sumneko_lua"), opts) or {})
    require("neodev").setup({
      override = function(root_dir, library)
        print(root_dir)
        if require("neodev.util").has_file(root_dir, "~/.local/share/chezmoi/dot_config/nvim") then
          library.enabled = true
          library.plugins = true
        end
      end,
    })
  end,

  ["jsonls"] = function()
    lspconfig.jsonls.setup(vim.tbl_deep_extend("force", require("config.lsp.settings.jsonls"), opts) or {})
  end,

  ["yamlls"] = function()
    lspconfig.yamlls.setup(vim.tbl_deep_extend("force", require("config.lsp.settings.yamlls"), opts) or {})
  end,

  ["denols"] = function()
    lspconfig.denols.setup(vim.tbl_deep_extend("force", require("config.lsp.settings.denols"), opts) or {})
  end,

  ["tsserver"] = function()
    opts = vim.tbl_deep_extend("force", require("config.lsp.settings.tsserver"), opts) or {}
    require("typescript").setup({ server = opts })
  end,

  ["jdtls"] = function()
    --[[ require("jdtls").start_or_attach(vim.tbl_deep_extend("force", opts, require("config.lsp.settings.jdtls")) or {}) ]]
  end,
})
