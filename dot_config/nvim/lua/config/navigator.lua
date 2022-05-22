local status_ok, navigator = pcall(require, "navigator")
if not status_ok then
  return
end

print("hello")

navigator.setup({
  width = 0.7,
  lsp_installer = false,
  ts_fold = false,
  lsp_signature_help = true,

  lsp = {
    format_on_save = true,
    disable_format_cap = { "sqls", "gopls", "jsonls" },
    disable_lsp = {},
    code_lens = true,
    disply_diagnostic_qf = false,
    denols = { filetypes = {} },
    tsserver = {
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      on_attach = function(client)
        client.server_capabilities.document_formatting = false
      end,
    },
    flow = { autostart = false },

    sqls = {
      on_attach = function(client)
        client.server_capabilities.document_formatting = false -- efm
      end,
    },
    ccls = { filetypes = {} }, -- using clangd

    jedi_language_server = { filetypes = {} }, --another way to disable lsp
    server = { "terraform_lsp" },
  },
})
