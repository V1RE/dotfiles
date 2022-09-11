local hop = require("hop")
local icons = require("config.icons")
local utils = require("utils")

hop.setup()

utils.map({ ["<TAB>"] = { icons.Rocket .. "Hop", hop.hint_words } })
