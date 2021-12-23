local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { exe = "phpstan", filetypes = { "php" } },
}

require("lvim.lsp.manager").setup "intelephense"
require("lvim.lsp.manager").setup "tailwindcss"
