local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { exe = "shellcheck", filetypes = { "sh" } },
}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "shfmt", filetypes = { "sh" } },
}

require("lvim.lsp.manager").setup "bashls"
