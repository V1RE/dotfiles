require("config.lsp.handlers").setup()

require("config.lsp.mason")

vim.filetype.add({
  extension = {
    ["plist"] = "xml",
  },
  filename = {
    ["bun.lock"] = "jsonc",
    ["*.env.*"] = "sh",
    ["Podfile"] = "ruby",
    ["Appfile"] = "ruby",
    ["Fastfile"] = "ruby",
    ["Matchfile"] = "ruby",
    ["Pluginfile"] = "ruby",
    ["*.ejs.t"] = "embedded_template",
    ["*.hbs"] = "html",
    ["*.liquid"] = "liquid.html",
    [".prettierignore"] = "gitignore",
    ["dot_zshrc"] = "zsh",
    ["dot_zshenv"] = "zsh",
  },
})
