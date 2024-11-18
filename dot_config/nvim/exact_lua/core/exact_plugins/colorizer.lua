---@type LazyPluginSpec
local M = {
  "NvChad/nvim-colorizer.lua",
  opts = {
    user_default_options = {
      names = false,
      css_fn = true,
      mode = "background",
      tailwind = true,
      sass = { enable = true, parsers = { css = true } },
      virtualtext = "■",
    },
    buftypes = { "*", "!terminal", "!prompt", "!popup", "!nofile" },
  },
  event = "BufReadPre",
  enabled = false,
}

return M
