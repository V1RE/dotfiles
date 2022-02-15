local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { exe = "luacheck" },
}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "stylua" },
}

require("lvim.lsp.manager").setup "sumneko_lua"
