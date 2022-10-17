local M = {}
local i = require("config.icons")

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = require("cmp_nvim_lsp").default_capabilities(M.capabilities)

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = i.Error },
    { name = "DiagnosticSignWarn", text = i.Warning },
    { name = "DiagnosticSignHint", text = i.Hint },
    { name = "DiagnosticSignInfo", text = i.Information },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  vim.diagnostic.config({
    virtual_lines = false,
    virtual_text = false,
    signs = {
      active = signs,
    },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

M.on_attach = function(client, bufnr)
  require("illuminate").on_attach(client)
  require("aerial").on_attach(client, bufnr)
  --[[ require("lsp-inlayhints").on_attach(client, bufnr, false) ]]

  if client.name == "tsserver" then
    require("which-key").register({
      ["<leader>"] = {
        l = {
          t = { "<cmd>TypescriptRemoveUnused<cr>", "Remove unused imports" },
        },
      },
    }, { buffer = bufnr })
  end
end

return M
