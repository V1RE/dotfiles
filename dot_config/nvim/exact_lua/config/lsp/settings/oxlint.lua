---@type vim.lsp.Config
local oxlint = {
  cmd = { "oxlint", "--lsp" },
  root_dir = function(bufnr, on_dir)
    local root_markers = { ".oxlintrc.json", "vite.config.ts" }
    root_markers = vim.list_extend(root_markers, { ".git" })
    local project_root = vim.fs.root(bufnr, root_markers)
    on_dir(project_root or vim.fn.getcwd())
  end,
}

return oxlint
