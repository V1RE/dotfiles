local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { exe = "eslint_d", filetypes = { "javascriptreact" } },
}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "eslint_d", filetypes = { "javascriptreact" } },
}

require("lvim.lsp.manager").setup "tsserver"
