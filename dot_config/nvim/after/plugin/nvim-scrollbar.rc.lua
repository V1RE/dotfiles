local colors = require("catppuccin.palettes.macchiato")

require("scrollbar").setup({
  handle = {
    color = colors.overlay0,
  },
  marks = {
    Search = { color = colors.peach },
    Error = { color = colors.red },
    Warn = { color = colors.maroon },
    Info = { color = colors.blue },
    Hint = { color = colors.sky },
    Misc = { color = colors.lavender },
  },
})
