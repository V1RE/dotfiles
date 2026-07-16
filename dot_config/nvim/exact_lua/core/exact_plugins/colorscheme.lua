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
      default_integrations = false,
      auto_integrations = true,
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
      integrations = {
        mini = true,
      },
      custom_highlights = function(colors)
        return {
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
        }
      end,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
