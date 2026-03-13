---@type LazyPluginSpec[]
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    ---@type CatppuccinOptions
    opts = {
      flavour = "macchiato",
      transparent_background = true,
      term_colors = false,
      styles = {
        comments = { "italic" },
        functions = { "italic" },
        keywords = {},
        strings = {},
        variables = {},
      },
      lsp_styles = {
        underlines = {
          errors = { "undercurl" },
          hints = { "underdouble" },
          warnings = { "undercurl" },
          information = { "underdashed" },
        },
      },
      default_integrations = true,
      integrations = {
        aerial = true,
        cmp = true,
        gitsigns = true,
        indent_blankline = {
          enabled = true,
        },
        mason = true,
        mini = true,
        neotree = true,
        noice = true,
        snacks = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
      custom_highlights = function(colors)
        return {
          Comment = { fg = colors.overlay1 },
          LineNr = { fg = colors.overlay1 },
          CursorLine = { bg = "NONE" },
          CursorLineNr = { fg = colors.lavender },
          DiagnosticVirtualTextError = { bg = "NONE" },
          DiagnosticVirtualTextWarn = { bg = "NONE" },
          DiagnosticVirtualTextInfo = { bg = "NONE" },
          DiagnosticVirtualTextHint = { bg = "NONE" },
          DiagnosticUnderlineError = { undercurl = true },
          DiagnosticUnderlineWarn = { undercurl = true },
          DiagnosticUnderlineInfo = { underdashed = true },
          DiagnosticUnderlineHint = { underdashed = true },
          NotifyBackground = { bg = colors.base },
        }
      end,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
