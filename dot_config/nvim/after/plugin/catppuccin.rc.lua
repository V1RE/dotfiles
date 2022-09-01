return
vim.g.catppuccin_flavour = "macchiato"

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
  compile = {
    enabled = true,
    path = vim.fn.stdpath("cache") .. "/catppuccin",
  },
})

vim.cmd([[colorscheme catppuccin]])
