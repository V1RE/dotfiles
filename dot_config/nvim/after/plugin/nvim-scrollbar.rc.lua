local colors = require("catppuccin.palettes").get_palette()

require("scrollbar").setup({
  handle = {
    color = colors.bg_highlight,
  },
})
