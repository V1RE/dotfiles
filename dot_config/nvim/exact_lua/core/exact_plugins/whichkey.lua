---@type LazyPluginSpec
local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = function()
    local i = require("dot_config.nvim.exact_lua.config.icons")

    ---@type wk.Opts
    return {
      ---@type wk.Spec
      spec = {
        { "<leader>b", group = "Buffer", nowait = true, remap = false, icon = i.Buffer },
        { "<leader>bd", "<cmd>Bdelete<CR>", desc = "Close", nowait = true, remap = false, icon = i.Close },
        { "<leader>bs", "<cmd>w!<CR>", desc = "Save", nowait = true, remap = false, icon = i.Save },
        {
          "<leader>h",
          "<cmd>nohlsearch<CR>",
          desc = "Clear highlight",
          nowait = true,
          remap = false,
          icon = i.NoHighlight,
        },
        { "<leader>j", group = "Window", nowait = true, remap = false, icon = i.Window },
        { "<leader>ja", "<cmd>qa<CR>", desc = "Close all", nowait = true, remap = false, icon = i.CloseAll },
        { "<leader>jd", "<cmd>q<CR>", desc = "Close", nowait = true, remap = false, icon = i.Close },
        { "<leader>l", group = "LSP", nowait = true, remap = false, icon = i.Field },
        { "<leader>lI", "<cmd>Mason<cr>", desc = "Installer Info", nowait = true, remap = false, icon = i.Dashboard },
        { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action", nowait = true, remap = false, icon = i.Comment },
        {
          "<leader>lf",
          function()
            vim.lsp.buf.format({
              filter = function(client)
                return client.name == "null-ls"
              end,
            })
          end,
          desc = "Format",
          nowait = true,
          remap = false,
          icon = i.Code,
        },
        { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info", nowait = true, remap = false, icon = i.Information },
        {
          "<leader>lj",
          vim.diagnostic.goto_next,
          desc = "Next Diagnostic",
          nowait = true,
          remap = false,
          icon = i.ChevronRight,
        },
        {
          "<leader>lk",
          vim.diagnostic.goto_prev,
          desc = "Prev Diagnostic",
          nowait = true,
          remap = false,
          icon = i.ChevronLeft,
        },
        { "<leader>ll", vim.lsp.codelens.run, desc = "CodeLens Action", nowait = true, remap = false, icon = i.Hint },
        { "<leader>lr", vim.lsp.buf.rename, desc = "Rename", nowait = true, remap = false, icon = i.Rename },
        { "<leader>p", group = "Lazy", nowait = true, remap = false, icon = i.Lazy },
        { "<leader>pr", "<cmd>so %<cr>", desc = "Source current file", nowait = true, remap = false, icon = i.History },
        { "<leader>ps", "<cmd>Lazy<cr>", desc = "Open lazy", nowait = true, remap = false, icon = i.Dashboard },
        { "K", vim.lsp.buf.hover, desc = "Hover", nowait = true, remap = false, icon = i.Note },
        { "g", group = "Go to", nowait = true, remap = false, icon = i.Goto },
        { "gl", vim.diagnostic.open_float, desc = "Diagnostics", nowait = true, remap = false, icon = i.Warning },
      },
    }
  end,
}

return M
