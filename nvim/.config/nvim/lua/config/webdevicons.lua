local webdevicons = require("nvim-web-devicons")

webdevicons.setup({
  override = {
    [".prettierrc.js"] = {
      icon = "",
      color = "#f6b44a",
      cterm_color = "215",
    },
  },
})
