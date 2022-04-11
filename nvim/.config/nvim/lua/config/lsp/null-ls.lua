local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local linters = null_ls.builtins.diagnostics
-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#code-actions
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
  debug = false,
  sources = {
    formatting.stylelint,
    formatting.eslint_d,
    formatting.prettierd,
    formatting.stylua,
    formatting.rubocop,
    formatting.google_java_format,
    linters.stylelint,
    linters.luacheck,
    linters.rubocop,
    linters.eslint_d,
    code_actions.eslint_d,
  },
})
