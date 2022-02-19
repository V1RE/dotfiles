local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
  { exe = "rustfmt" },
})

require("lvim.lsp.manager").setup("rust_analyzer")
