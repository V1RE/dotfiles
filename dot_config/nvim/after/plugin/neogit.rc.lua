local utils = require("utils")
local neogit = require("neogit")
local icons = require("config.icons")

utils.map({
  ["<leader>"] = {
    g = { neogit.open, icons.Diff .. "Neogit" },
  },
})
