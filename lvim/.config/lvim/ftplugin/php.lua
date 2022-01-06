local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { exe = "phpstan" },
}

require("lvim.lsp.manager").setup "intelephense"
require("lvim.lsp.manager").setup "tailwindcss"
