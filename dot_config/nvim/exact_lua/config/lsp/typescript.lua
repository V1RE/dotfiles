local M = {}

function M.local_tsc(root)
  return vim.fs.joinpath(root, "node_modules", ".bin", "tsc")
end

local function typescript_major_version(root)
  local package_json = vim.fs.joinpath(root, "node_modules", "typescript", "package.json")
  local read_ok, lines = pcall(vim.fn.readfile, package_json)
  if not read_ok then
    return nil
  end

  local decode_ok, package = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not decode_ok or type(package) ~= "table" or type(package.version) ~= "string" then
    return nil
  end

  return tonumber(package.version:match("^(%d+)"))
end

function M.is_native_typescript_root(root)
  if not root or vim.fn.executable(M.local_tsc(root)) ~= 1 then
    return false
  end

  local major_version = typescript_major_version(root)
  return major_version ~= nil and major_version >= 7
end

return M
