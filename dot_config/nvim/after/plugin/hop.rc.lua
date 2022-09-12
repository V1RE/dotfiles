local hop = require("hop")
local icons = require("config.icons")
local utils = require("utils")

hop.setup()

utils.map({ ["<TAB>"] = { hop.hint_words, icons.Rocket .. "Hop" } })
