local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "prettierd" },
}

require("lvim.lsp.manager").setup "jsonls"
