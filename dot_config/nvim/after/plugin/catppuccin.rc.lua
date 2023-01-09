vim.g.catppuccin_flavour = "macchiato"

local colors = require("catppuccin.palettes").get_palette()
colors.none = "NONE"

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
    hop = true,
    aerial = true,
    notify = true,
    neotree = true,
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
    NvimTreeOpenedFile = { fg = colors.peach },
    Comment = { fg = colors.overlay1 },
    LineNr = { fg = colors.overlay1 },
    CursorLine = { bg = colors.none },
    CursorLineNr = { fg = colors.lavender },
    DiagnosticVirtualTextError = { bg = colors.none },
    DiagnosticVirtualTextWarn = { bg = colors.none },
    DiagnosticVirtualTextInfo = { bg = colors.none },
    DiagnosticVirtualTextHint = { bg = colors.none },
  },
})

vim.cmd("colorscheme catppuccin")
