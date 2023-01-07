local ssr = require("ssr")
local util = require("utils")

ssr.setup()

util.map({
  ["<leader>"] = {
    l = {
      R = { ssr.open, "SSR" },
    },
  },
})
