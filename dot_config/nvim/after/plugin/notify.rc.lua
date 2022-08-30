require("notify.init").setup({
  timeout = 2000,
  max_width = 80,
})

vim.notify = require("notify")
