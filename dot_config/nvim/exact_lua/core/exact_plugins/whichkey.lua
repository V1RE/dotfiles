---@type LazyPluginSpec
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = function()
    local i = require("config.icons")

    ---@type wk.Opts
    return {
      preset = "helix",
      ---@type wk.Spec
      spec = {
        { "<leader>b", group = "Buffer", icon = i.Buffer },
        {
          "<leader>bd",
          function()
            Snacks.bufdelete()
          end,
          desc = "Close",
          icon = i.Close,
        },
        { "<leader>bs", "<cmd>w!<CR>", desc = "Save", icon = i.Save },
        {
          "<leader>h",
          "<cmd>nohlsearch<CR>",
          desc = "Clear highlight",
          icon = i.NoHighlight,
        },
        { "<leader>j", group = "Window", icon = i.Window },
        { "<leader>ja", "<cmd>qa<CR>", desc = "Close all", icon = i.CloseAll },
        { "<leader>jd", "<cmd>q<CR>", desc = "Close", icon = i.Close },
        { "<leader>l", group = "LSP", icon = i.Field },
        { "<leader>lI", "<cmd>Mason<cr>", desc = "Installer Info", icon = i.Dashboard },
        { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action", icon = i.Comment },
        {
          "<leader>lf",
          function()
            vim.lsp.buf.format({ async = true })
          end,
          desc = "Format",
          icon = i.Code,
        },
        { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info", icon = i.Information },
        {
          "<leader>lj",
          function()
            vim.diagnostic.jump({ count = 1, float = true })
          end,
          desc = "Next Diagnostic",
          icon = i.ChevronRight,
        },
        {
          "<leader>lk",
          function()
            vim.diagnostic.jump({ count = -1, float = true })
          end,
          desc = "Prev Diagnostic",
          icon = i.ChevronLeft,
        },
        { "<leader>ll", vim.lsp.codelens.run, desc = "CodeLens Action", icon = i.Hint },
        { "<leader>lr", vim.lsp.buf.rename, desc = "Rename", icon = i.Rename },
        { "<leader>p", group = "Lazy", icon = i.Lazy },
        { "<leader>pr", "<cmd>so %<cr>", desc = "Source current file", icon = i.History },
        { "<leader>ps", "<cmd>Lazy<cr>", desc = "Open lazy", icon = i.Dashboard },
        { "K", vim.lsp.buf.hover, desc = "Hover", icon = i.Note },
        { "g", group = "Go to", icon = i.Goto },
        { "gl", vim.diagnostic.open_float, desc = "Diagnostics", icon = i.Warning },
      },
    }
  end,
}
