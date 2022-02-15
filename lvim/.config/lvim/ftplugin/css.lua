local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "prettierd" },
}

require("lvim.lsp.manager").setup "cssls"
require("lvim.lsp.manager").setup "tailwindcss"
