local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "prettier", filetypes = { "json" } },
}

require("lvim.lsp.manager").setup "jsonls"
