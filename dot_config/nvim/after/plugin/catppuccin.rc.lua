vim.g.catppuccin_flavour = "macchiato"

local colors = require("catppuccin.palettes").get_palette()

require("catppuccin").setup({
  transparent_background = true,
  term_colors = false,
  styles = {
    comments = { "italic" },
    functions = { "italic" },
    keywords = {},
    strings = {},
    variables = {},
  },
  integrations = {
    cmp = true,
    telescope = true,
    which_key = true,
    navic = true,
    hop = true,
    indent_blankline = {
      enabled = true,
      colored_indent_levels = true,
    },
  },
  compile = {
    enabled = true,
    path = vim.fn.stdpath("cache") .. "/catppuccin",
  },
  custom_highlights = {
    NvimTreeOpenedFile = { fg = colors.blue },
  },
})

vim.cmd("colorscheme catppuccin")
