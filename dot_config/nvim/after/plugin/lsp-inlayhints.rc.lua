local status, hints = pcall(require, "lsp-inlayhints")
if not status then
  return
end

local default_config = {
  inlay_hints = {
    parameter_hints = {
      show = true,
    },
    type_hints = {
      show = true,
    },
    only_current_line = false,
    label_formatter = function(labels, kind, opts)
      if kind == 2 and not opts.parameter_hints.show then
        return ""
      elseif not opts.type_hints.show then
        return ""
      end

      return table.concat(labels or {}, ", ")
    end,
    virt_text_formatter = function(label, hint, opts, client_name)
      if client_name == "sumneko_lua" then
        if hint.kind == 2 then
          hint.paddingLeft = false
        else
          hint.paddingRight = false
        end
      end

      local virt_text = {}
      virt_text[#virt_text + 1] = hint.paddingLeft and { " ", "Normal" } or nil
      virt_text[#virt_text + 1] = { label, opts.highlight }
      virt_text[#virt_text + 1] = hint.paddingRight and { " ", "Normal" } or nil

      return virt_text
    end,

    -- highlight group
    highlight = "LspInlayHint",
  },
  enabled_at_startup = true,
  debug_mode = false,
}
hints.setup({ default_config })

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
})
