vim.pretty_print(vim.api.nvim_exec("args", true))
---@type LazyPluginSpec[]
local M = {
  {
    "Lilja/vim-chezmoi",
    cond = function()
      return nil ~= vim.api.nvim_exec("args", true):find("chezmoi")
    end,
    init = function()
      vim.g.chezmoi = "enabled"
    end,
  },
  {
    "alker0/chezmoi.vim",
    event = "VeryLazy",
    cond = function()
      return nil ~= vim.api.nvim_exec("args", true):find("chezmoi")
    end,
  },
}

return M
