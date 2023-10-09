local typescript = {"eslint_d",{"prettierd","prettier"}}

---@type LazyPluginSpec
local M = {
  'stevearc/conform.nvim',
  opts = {
    ---@type table<string, conform.FormatterUnit[]>
    formatters_by_ft = {
      javascript = typescript,
      typescript = typescript,
      typescriptreact = typescript,
      javascriptreact = typescript,
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
    },
  },
  enabled = false
}

return M
