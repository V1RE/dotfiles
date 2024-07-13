local wk = require("which-key")

local i = require("config.icons")

wk.setup({
  icons = {
    breadcrumb = " ",
    separator = " ",
    group = "",
  },
  spec = {
    { "<leader>b", group = " Buffer", nowait = true, remap = false },
    { "<leader>bd", "<cmd>Bdelete<CR>", desc = " Close", nowait = true, remap = false },
    { "<leader>bs", "<cmd>w!<CR>", desc = " Save", nowait = true, remap = false },
    { "<leader>h", "<cmd>nohlsearch<CR>", desc = " Clear highlight", nowait = true, remap = false },
    { "<leader>j", group = " Window", nowait = true, remap = false },
    { "<leader>ja", "<cmd>qa<CR>", desc = " Close all", nowait = true, remap = false },
    { "<leader>jd", "<cmd>q<CR>", desc = " Close", nowait = true, remap = false },
    { "<leader>l", group = " LSP", nowait = true, remap = false },
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
    { "<leader>p", group = " Packer", nowait = true, remap = false },
    { "<leader>pr", "<cmd>so %<cr>", desc = "Source current file", nowait = true, remap = false },
    { "<leader>ps", "<cmd>PackerSync<CR>", desc = " Sync", nowait = true, remap = false },
    { "<leader>pu", "<cmd>PackerUpdate<CR>", desc = " Update", nowait = true, remap = false },
    { "K", vim.lsp.buf.hover, desc = i.Comment .. "Hover" },
    { "g", group = i.Goto .. "Go to", nowait = true, remap = false },
    { "ga", vim.lsp.buf.range_code_action, desc = i.Event .. "Code actions", nowait = true, remap = false },
    { "gl", vim.diagnostic.open_float, desc = i.Warning .. "Diagnostics", nowait = true, remap = false },
  },
})
