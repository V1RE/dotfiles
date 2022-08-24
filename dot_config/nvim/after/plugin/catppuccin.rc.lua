require("catppuccin").setup({
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
  dim_inactive = {
    enabled = true,
  },
  compile = {
    enable = true,
  },
})

require("colorscheme")
