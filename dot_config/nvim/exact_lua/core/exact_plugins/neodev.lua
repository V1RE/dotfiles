---@type LazyPluginSpec
local M = {
  "folke/neodev.nvim",
  config = function()
    local util = require("neodev.util")
    require("neodev").setup({
      library = {
        plugins = true,
        types = true,
      },
      override = function(root_dir, library)
        if util.has_file(root_dir, "~/.local/share/chezmoi") or util.has_file(root_dir, "~/.config/nvim") then
          library.enabled = true
          library.plugins = true
        end
      end,
    })
  end,
  enabled = false,
}

return M
