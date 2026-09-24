---@type vim.lsp.Config
return {
  cmd = { "shuck", "server" },
  filetypes = { "sh", "bash", "zsh", "ksh", "mksh" },
  root_markers = { ".shuck.toml", "shuck.toml", ".git" },
  on_attach = function(client, bufnr)
    if not client:supports_method("textDocument/formatting") then
      return
    end

    local group = vim.api.nvim_create_augroup("ShuckFormatting", { clear = false })
    vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr, name = "shuck", timeout_ms = 3000 })
      end,
    })
  end,
}
