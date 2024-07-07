---@type LazySpec[]
local M = {
  { import = "core.plugins.lsp.typescript", ft = { "typescript", "typescriptreact" } },
  { import = "core.plugins.lsp.go", ft = { "go", "gomod", "gosum" }, enabled = false },
  { import = "core.plugins.lsp.java", ft = { "java" }, enabled = false },
  { import = "core.plugins.lsp.dap", enabled = false },
  {
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("inlay-hints").setup()
    end,
  },
}

return M
