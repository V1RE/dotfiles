vim.pretty_print()
---@type LazyPluginSpec[]
local M = {
  {
    "Lilja/vim-chezmoi",
    cond = function()
      return nil == string.find(vim.cmd("args"), "chezmoi")
    end,
    init = function()
      vim.g.chezmoi = "enabled"
    end,
  },
  {
    "alker0/chezmoi.vim",
    event = "VeryLazy",
    cond = function()
      return nil == string.find(vim.cmd("args"), "chezmoi")
    end,
  },
}

return M
