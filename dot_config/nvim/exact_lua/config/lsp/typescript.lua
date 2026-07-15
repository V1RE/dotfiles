local M = {}

function M.local_tsc(root)
  return vim.fs.joinpath(root, "node_modules", ".bin", "tsc")
end

function M.is_effect_tsgo_root(root)
  if not root then
    return false
  end

  return vim.fn.executable(vim.fs.joinpath(root, "node_modules", ".bin", "effect-tsgo")) == 1
    and vim.fn.executable(M.local_tsc(root)) == 1
end

return M
