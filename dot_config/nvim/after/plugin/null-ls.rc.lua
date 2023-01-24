local null_ls = require("null-ls")

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local linters = null_ls.builtins.diagnostics
-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#code-actions
local code_actions = null_ls.builtins.code_actions
-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#hover
local hover = null_ls.builtins.hover

null_ls.setup({
  debug = false,
  sources = {
    code_actions.eslint_d,
    code_actions.shellcheck,
    require("typescript.extensions.null-ls.code-actions"),
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.formatting.google_java_format,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.stylelint,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.jq,
    hover.dictionary,
    linters.eslint_d.with({
      condition = function(utils)
        return utils.root_has_file({
          ".eslintrc",
          ".eslintrc.js",
          ".eslintrc.cjs",
          ".eslintrc.yaml",
          ".eslintrc.yml",
          ".eslintrc.json",
        })
      end,

      extra_filetypes = { "graphql" },
    }),
    linters.luacheck,
    linters.shellcheck,
    linters.stylelint.with({
      condition = function(utils)
        return utils.root_has_file({
          ".stylelintrc",
          ".stylelintrc.js",
          ".stylelintrc.cjs",
          ".stylelintrc.yaml",
          ".stylelintrc.yml",
          ".stylelintrc.json",
        })
      end,
    }),
    linters.write_good,
    linters.zsh,
    linters.actionlint,
  },
  on_attach = function(client, bufnr)
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            filter = function(server)
              return server.name ~= "tsserver"
            end,
            bufnr = bufnr,
          })
        end,
      })
    end
  end,
})
