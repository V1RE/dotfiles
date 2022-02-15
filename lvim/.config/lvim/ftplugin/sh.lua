local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { exe = "shellcheck" },
}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "shfmt" },
}

require("lvim.lsp.manager").setup "bashls"
