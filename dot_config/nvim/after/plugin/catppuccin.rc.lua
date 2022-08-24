require("catppuccin").setup({
  transparent_background = false,
  term_colors = true,
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
    indent_blankline = {
      enabled = true,
      colored_indent_levels = true,
    },
  },
})

require("colorscheme")
