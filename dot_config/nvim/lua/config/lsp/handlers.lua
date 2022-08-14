local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
  return
end
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.update_capabilities(M.capabilities)

M.setup = function()
  local icons = require("config.icons")
  local signs = {
    { name = "DiagnosticSignError", text = icons.Error },
    { name = "DiagnosticSignWarn", text = icons.Warning },
    { name = "DiagnosticSignHint", text = icons.Hint },
    { name = "DiagnosticSignInfo", text = icons.Information },
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
  local status_ok, illuminate = pcall(require, "illuminate")
  if not status_ok then
    return
  end
  illuminate.on_attach(client)
end

local function attach_navic(client, bufnr)
  vim.g.navic_silence = true
  local status_ok = pcall(require, "nvim-navic")
  if not status_ok then
    return
  end
  require("nvim-navic").attach(client, bufnr)
end

M.on_attach = function(client, bufnr)
  lsp_highlight_document(client)
  attach_navic(client, bufnr)

  --[[ if client.name == "tsserver" then ]]
  --[[   require("lsp-inlayhints").on_attach(bufnr, client, false) ]]
  --[[ end ]]
end

return M
