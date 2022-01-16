local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { exe = "eslint_d" },
}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "eslint_d" },
}

require("lvim.lsp.manager").setup "tsserver"

local lspconfig = require "lspconfig"

local denoOptions = {
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
}

require("lvim.lsp.manager").setup("denols", denoOptions)
