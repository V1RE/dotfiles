--[[ local status, hints = pcall(require, "lsp-inlayhints")
if not status then
  return
end

hints.setup({})

vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_inlayhints",
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    hints.on_attach(client, bufnr, false)
  end,
}) ]]
