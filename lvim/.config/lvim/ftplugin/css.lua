local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "prettier", filetypes = { "css" } },
}

require("lvim.lsp.manager").setup "cssls"
require("lvim.lsp.manager").setup "tailwindcss"
