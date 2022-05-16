local webdevicons = require("nvim-web-devicons")

webdevicons.setup({
  override = {
    [".prettierrc.js"] = {
      icon = "",
      color = "#f6b44a",
      cterm_color = "215",
      name = "Prettier",
    },
    zip = {
      icon = "",
      color = "#ebc846",
      cterm_color = "221",
      name = "Zip",
    },
  },
})
