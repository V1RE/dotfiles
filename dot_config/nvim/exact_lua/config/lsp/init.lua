require("config.lsp.handlers").setup()

require("config.lsp.mason")

vim.filetype.add({
  extension = {
    ["plist"] = "xml",
  },
  filename = {
    ["bun.lock"] = "jsonc",
  },
})
