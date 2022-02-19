local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
  { exe = "stylelint" },
})

local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
  { exe = "stylelint" },
})

require("lvim.lsp.manager").setup("cssls")
