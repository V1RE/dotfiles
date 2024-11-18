---@type LazySpec[]
local M = {
  { import = "core.plugins.lsp.typescript", ft = { "typescript", "typescriptreact" } },
  { import = "core.plugins.lsp.go", ft = { "go", "gomod", "gosum" }, enabled = false },
}

return M
