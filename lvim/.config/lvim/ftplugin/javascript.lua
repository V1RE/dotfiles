local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { exe = "eslint_d", filetypes = { "javascript" } },
}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "eslint_d", filetypes = { "javascript" } },
}

require("lvim.lsp.manager").setup "tsserver"
