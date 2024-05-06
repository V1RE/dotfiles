local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      -- apply whatever logic you want (in this example, we'll only use null-ls)
      return client.name == "null-ls" or client.name == "rustfmt"
    end,
    bufnr = bufnr,
  })
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local on_attach = function(client, bufnr)
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
end

---@type LazyPluginSpec[]
local M = {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      local null_ls = require("null-ls")

      local formatting = null_ls.builtins.formatting
      local linters = null_ls.builtins.diagnostics
      local hover = null_ls.builtins.hover

      null_ls.setup({
        debug = false,
        sources = {
          require("none-ls.code_actions.eslint_d").with({
            condition = function(utils)
              return utils.root_has_file({
                "node_modules/.bin/eslint",
              }) and not utils.root_has_file({
                "biome.json",
              })
            end,
          }),
          -- code_actions.shellcheck,
          require("none-ls.formatting.eslint_d").with({
            condition = function(utils)
              return utils.root_has_file({
                "node_modules/.bin/eslint",
              }) and not utils.root_has_file({
                "biome.json",
              })
            end,
          }),
          -- formatting.deno_fmt.with({
          --   condition = function(utils)
          --     return utils.root_has_file({
          --       "deno.json",
          --     })
          --   end,
          -- }),
          formatting.biome,
          formatting.google_java_format,
          formatting.prettierd.with({
            condition = function(utils)
              return utils.root_has_file({
                ".prettierignore",
              })
            end,
          }),
          formatting.shfmt,
          formatting.stylua,
          -- formatting.beautysh,
          -- formatting.rustfmt,
          -- formatting.jq,
          hover.dictionary,
          require("none-ls.diagnostics.eslint_d").with({
            condition = function(utils)
              return utils.root_has_file({
                "node_modules/.bin/eslint",
              }) and not utils.root_has_file({
                "biome.json",
              })
            end,
          }),
          -- linters.luacheck,
          -- linters.shellcheck,
          linters.zsh,
          linters.actionlint,
        },
        on_attach = on_attach,
      })
    end,
  },
}

return M
