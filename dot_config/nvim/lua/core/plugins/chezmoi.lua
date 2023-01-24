---@type LazyPluginSpec[]
local M = {
  {
    "Lilja/vim-chezmoi",
    enabled = function()
      return nil ~= require("core.util").get_root():find(".local/chezmoi")
    end,
    init = function()
      vim.g.chezmoi = "enabled"
    end,
  },
  {
    "alker0/chezmoi.vim",
    enabled = function()
      return nil ~= require("core.util").get_root():find(".local/chezmoi")
    end,
  },
}

return M
