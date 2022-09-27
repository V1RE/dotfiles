local opts = {
  on_attach = require("config.lsp.handlers").on_attach,
  capabilities = require("config.lsp.handlers").capabilities,
}

require("jdtls").start_or_attach(vim.tbl_deep_extend("force", opts, require("config.lsp.settings.jdtls")) or {})
