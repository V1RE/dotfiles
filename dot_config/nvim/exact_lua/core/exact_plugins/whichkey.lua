---@type LazyPluginSpec
local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = function()
    local i = require("config.icons")

    ---@type wk.Opts
    return {
      ---@type wk.Spec
      spec = {
        { "<leader>b", group = i.Buffer .. "Buffer", nowait = true, remap = false, icon = i.Buffer },
        { "<leader>bd", "<cmd>Bdelete<CR>", desc = i.Close .. "Close", nowait = true, remap = false },
        { "<leader>bs", "<cmd>w!<CR>", desc = i.Save .. "Save", nowait = true, remap = false },
        { "<leader>h", "<cmd>nohlsearch<CR>", desc = i.NoHighlight .. "Clear highlight", nowait = true, remap = false },
        { "<leader>j", group = i.Window .. "Window", nowait = true, remap = false },
        { "<leader>ja", "<cmd>qa<CR>", desc = i.CloseAll .. "Close all", nowait = true, remap = false },
        { "<leader>jd", "<cmd>q<CR>", desc = i.Close .. "Close", nowait = true, remap = false },
        { "<leader>l", group = i.Field .. "LSP", nowait = true, remap = false },
        { "<leader>lI", "<cmd>Mason<cr>", desc = "Installer Info", nowait = true, remap = false },
        { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action", nowait = true, remap = false },
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
        },
        { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info", nowait = true, remap = false },
        { "<leader>lj", vim.diagnostic.goto_next, desc = "Next Diagnostic", nowait = true, remap = false },
        { "<leader>lk", vim.diagnostic.goto_prev, desc = "Prev Diagnostic", nowait = true, remap = false },
        { "<leader>ll", vim.lsp.codelens.run, desc = "CodeLens Action", nowait = true, remap = false },
        { "<leader>lr", vim.lsp.buf.rename, desc = "Rename", nowait = true, remap = false },
        { "<leader>p", group = i.Lazy .. "Lazy", nowait = true, remap = false },
        { "<leader>pr", "<cmd>so %<cr>", desc = "Source current file", nowait = true, remap = false },
        { "<leader>ps", "<cmd>Lazy<cr>", desc = "Show", nowait = true, remap = false },
        { "K", vim.lsp.buf.hover, desc = i.Comment .. "Hover", nowait = true, remap = false },
        { "g", group = i.Goto .. "Go to", nowait = true, remap = false },
        { "gl", vim.diagnostic.open_float, desc = i.Warning .. "Diagnostics", nowait = true, remap = false },
      },
    }
  end,
}

return M
