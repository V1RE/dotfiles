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
    aerial = true,
    noice = true,
    neotree = true,
    indent_blankline = {
      enabled = true,
    },
    mason = true,
    treesitter = true,
    gitsigns = true,
    mini = true,
    snacks = true,
    treesitter_context = true,
    native_lsp = {
      enabled = true,
      underlines = {
        errors = { "undercurl" },
        hints = { "underdouble" },
        warnings = { "undercurl" },
        information = { "underdashed" },
      },
    },
  },
  default_integrations = true,
  custom_highlights = {
    Comment = { fg = colors.overlay1 },
    LineNr = { fg = colors.overlay1 },
    CursorLine = { bg = colors.none },
    CursorLineNr = { fg = colors.lavender },
    DiagnosticVirtualTextError = { bg = colors.none },
    DiagnosticVirtualTextWarn = { bg = colors.none },
    DiagnosticVirtualTextInfo = { bg = colors.none },
    DiagnosticVirtualTextHint = { bg = colors.none },
    DiagnosticUnderlineError = { style = { "undercurl" } },
    DiagnosticUnderlineWarn = { style = { "undercurl" } },
    DiagnosticUnderlineInfo = { style = { "underdashed" } },
    DiagnosticUnderlineHint = { style = { "underdashed" } },
    NotifyBackground = { bg = colors.base },
  },
})

vim.cmd("colorscheme catppuccin")
