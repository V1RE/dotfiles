local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { exe = "eslint_d" },
}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "eslint_d" },
  { exe = "prettierd" },
}

require("lvim.lsp.manager").setup "tsserver"
