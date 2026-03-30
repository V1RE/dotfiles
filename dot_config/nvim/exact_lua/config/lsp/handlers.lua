local api = vim.api
local M = {}
local i = require("config.icons")

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities = require("blink.cmp").get_lsp_capabilities(M.capabilities)
-- M.capabilities = require("cmp_nvim_lsp").default_capabilities(M.capabilities)

local sig_help_ns = vim.api.nvim_create_namespace("lsp_signature_help")

local function resolve_float_config(config)
  return vim.tbl_deep_extend("force", config or {}, { border = "rounded" })
end

local function trim_empty_lines(lines)
  local start_idx = 1
  local end_idx = #lines

  while start_idx <= end_idx and lines[start_idx]:match("^%s*$") do
    start_idx = start_idx + 1
  end

  while end_idx >= start_idx and lines[end_idx]:match("^%s*$") do
    end_idx = end_idx - 1
  end

  if start_idx > end_idx then
    return {}
  end

  return vim.list_slice(lines, start_idx, end_idx)
end

local function as_plaintext_lines(lines)
  local plain_lines = {} ---@type string[]

  for _, line in ipairs(lines) do
    if not line:match("^```") then
      plain_lines[#plain_lines + 1] = line
    end
  end

  return trim_empty_lines(plain_lines)
end

local function hover_handler(_, result, ctx, config)
  if api.nvim_get_current_buf() ~= ctx.bufnr then
    return
  end

  if not (result and result.contents) then
    return
  end

  local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
  lines = as_plaintext_lines(lines)

  if vim.tbl_isempty(lines) then
    return
  end

  return vim.lsp.util.open_floating_preview(lines, "text", resolve_float_config(config))
end

local function signature_help_handler(_, result, ctx, config)
  config = config or {}

  if api.nvim_get_current_buf() ~= ctx.bufnr then
    return
  end

  if not (result and result.signatures and result.signatures[1]) then
    if config.silent ~= true then
      print("No signature help available")
    end
    return
  end

  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local triggers = client
      and vim.tbl_get(client.server_capabilities, "signatureHelpProvider", "triggerCharacters")
    or nil
  local lines, hl = vim.lsp.util.convert_signature_help_to_markdown_lines(result, nil, triggers)

  if not lines then
    if config.silent ~= true then
      print("No signature help available")
    end
    return
  end

  lines = as_plaintext_lines(lines)

  if vim.tbl_isempty(lines) then
    if config.silent ~= true then
      print("No signature help available")
    end
    return
  end

  local fbuf, fwin = vim.lsp.util.open_floating_preview(lines, "text", resolve_float_config(config))

  if hl then
    vim.hl.range(fbuf, sig_help_ns, "LspSignatureActiveParameter", { hl[1], hl[2] }, { hl[3], hl[4] })
  end

  return fbuf, fwin
end

M.setup = function()
  vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = {
      current_line = true,
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = i.Error,
        [vim.diagnostic.severity.WARN] = i.Warning,
        [vim.diagnostic.severity.HINT] = i.Hint,
        [vim.diagnostic.severity.INFO] = i.Information,
      },
      texthl = {
        [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
        [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
        [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
        [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      },
      numhl = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
    severity_sort = true,
    float = {
      border = "rounded",
      source = true,
      header = "",
      prefix = "",
    },
  })

  vim.lsp.handlers["textDocument/hover"] = hover_handler
  vim.lsp.handlers["textDocument/signatureHelp"] = signature_help_handler

  vim.lsp.commands["editor.action.showReferences"] = function(command, ctx)
    local locations = command.arguments[3]
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client and locations and #locations > 0 then
      local items = vim.lsp.util.locations_to_items(locations, client.offset_encoding)
      vim.fn.setloclist(0, {}, " ", { title = "References", items = items, context = ctx })
      vim.api.nvim_command("lopen")
    end
  end
end

return M
