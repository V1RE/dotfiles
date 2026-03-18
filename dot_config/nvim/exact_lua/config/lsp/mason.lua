local default_options = {
  capabilities = require("config.lsp.handlers").capabilities,
}

local servers = {
  "lua_ls",
  "jsonls",
  "yamlls",
  -- "vtsls",
  "stylelint_lsp",
  "eslint",
  "sourcekit",
  "kotlin_language_server",
  "tsgo",
  "oxlint",
  "oxfmt",
}

---@param server string
local function merge_options(server)
  local ok, server_options = pcall(require, "config.lsp.settings." .. server)

  return vim.tbl_deep_extend("force", default_options, ok and server_options or {})
end

for _, server in ipairs(servers) do
  vim.lsp.config(server, merge_options(server))
  vim.lsp.enable(server)
end
