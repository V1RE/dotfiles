local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { exe = "luacheck", filetypes = { "lua" } },
}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "stylua", filetypes = { "lua" } },
}

require("lvim.lsp.manager").setup "sumneko_lua"
