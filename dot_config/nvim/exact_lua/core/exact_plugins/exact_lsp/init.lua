---@type LazySpec[]
local M = {
  { import = "core.plugins.lsp.typescript", ft = { "typescript", "typescriptreact" } },
  { import = "core.plugins.lsp.java", ft = { "java" } },
  { import = "core.plugins.lsp.dap" },
}

return M
