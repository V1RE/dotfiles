local M = {}
local i = require("config.icons")

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = require("cmp_nvim_lsp").update_capabilities(M.capabilities)

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

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

local function lsp_highlight_document(client)
  require("illuminate").on_attach(client)
end

local function attach_navic(client, bufnr)
  vim.g.navic_silence = true
  require("nvim-navic").attach(client, bufnr)
end

M.on_attach = function(client, bufnr)
  lsp_highlight_document(client)
  attach_navic(client, bufnr)

  if client.name == "tsserver" then
    require("which-key").register({
      ["<leader>"] = {
        l = {
          t = { "<cmd>TypescriptRemoveUnused<cr>", "Remove unused imports" },
        },
      },
    }, { buffer = bufnr })
    require("lsp-inlayhints").on_attach(client, bufnr, false)
  end
end

return M
