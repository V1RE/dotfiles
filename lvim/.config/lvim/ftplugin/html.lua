local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "prettier", filetypes = { "html" } },
}

require("lvim.lsp.manager").setup "html"
