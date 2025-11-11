local M = {}
local i = require("config.icons")

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities = require("blink.cmp").get_lsp_capabilities(M.capabilities)
-- M.capabilities = require("cmp_nvim_lsp").default_capabilities(M.capabilities)

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

  vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
    config = config or {}
    config.border = config.border or "rounded"
    config.max_width = config.max_width or math.floor(vim.o.columns * 0.7)
    config.max_height = config.max_height or math.floor(vim.o.lines * 0.3)

    -- Ensure width/height are positive integers to prevent nvim_open_win errors
    if config.width then
      config.width = math.max(1, math.floor(config.width))
    end
    if config.height then
      config.height = math.max(1, math.floor(config.height))
    end

    vim.lsp.handlers.hover(err, result, ctx, config)
  end

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

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
