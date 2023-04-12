local null_ls = require("null-ls")

local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      return client.name ~= "tsserver" and client.name ~= "vtsls"
    end,
    bufnr = bufnr,
  })
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
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
    -- require("typescript.extensions.null-ls.code-actions"),
    formatting.eslint_d.with({
      condition = function(utils)
        return utils.root_has_file({
          "package.json",
        })
      end,
    }),
    formatting.deno_fmt.with({
      condition = function(utils)
        return not utils.root_has_file({
          "package.json",
        })
      end,
    }),
    formatting.google_java_format,
    formatting.prettierd.with({
      extra_filetypes = { "liquid" },
    }),
    formatting.shfmt,
    formatting.stylelint,
    formatting.stylua,
    formatting.beautysh,
    -- formatting.jq,
    hover.dictionary,
    linters.eslint_d.with({
      condition = function(utils)
        return utils.root_has_file({
          "package.json",
        })
      end,
    }),
    linters.luacheck,
    linters.shellcheck,
    -- linters.stylelint.with({
    --   condition = function(utils)
    --     return utils.root_has_file({
    --       ".stylelintrc",
    --       ".stylelintrc.js",
    --       ".stylelintrc.cjs",
    --       ".stylelintrc.yaml",
    --       ".stylelintrc.yml",
    --       ".stylelintrc.json",
    --     })
    --   end,
    -- }),
    linters.zsh,
    linters.actionlint,
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          lsp_formatting(bufnr)
        end,
      })
    end
  end,
})
