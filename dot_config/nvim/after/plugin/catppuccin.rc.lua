vim.g.catppuccin_flavour = "mocha"

require("catppuccin").setup({
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
    indent_blankline = {
      enabled = true,
      colored_indent_levels = true,
    },
  },
  dim_inactive = {
    enabled = true,
    shade = "dark",
    percentage = 0.42,
  },
  compile = {
    enabled = true,
    path = vim.fn.stdpath("cache") .. "/catppuccin",
  },
})

vim.cmd([[colorscheme catppuccin]])
