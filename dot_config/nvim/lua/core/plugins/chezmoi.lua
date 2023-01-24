---@type LazyPluginSpec[]
local M = {
  {
    "Lilja/vim-chezmoi",
    cond = function()
      return nil ~= require("core.util").get_root():find(".local/chezmoi")
    end,
    init = function()
      vim.g.chezmoi = "enabled"
    end,
  },
  {
    "alker0/chezmoi.vim",
    cond = function()
      return nil ~= require("core.util").get_root():find(".local/chezmoi")
    end,
  },
}

return M
