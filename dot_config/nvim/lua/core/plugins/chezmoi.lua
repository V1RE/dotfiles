vim.pretty_print(vim.cmd("args"))
---@type LazyPluginSpec[]
local M = {
  {
    "Lilja/vim-chezmoi",
    cond = function()
      return nil == require("core.util").get_root():find(".local/share/chezmoi")
    end,
    init = function()
      vim.g.chezmoi = "enabled"
    end,
  },
  {
    "alker0/chezmoi.vim",
    event = "VeryLazy",
    cond = function()
      return nil == require("core.util").get_root():find(".local/share/chezmoi")
    end,
  },
}

return M
