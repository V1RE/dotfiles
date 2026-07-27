local config_files = {
  ".fallowrc.json",
  ".fallowrc.jsonc",
  "fallow.toml",
  ".fallow.toml",
}

---@type vim.lsp.Config
local fallow = {
  cmd = { "fallow-lsp" },
  filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  single_file_support = false,

  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, config_files)
    if root then
      on_dir(root)
    end
  end,
}

return fallow
