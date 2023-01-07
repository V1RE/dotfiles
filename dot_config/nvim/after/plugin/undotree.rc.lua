local utils = require("utils")
local icons = require("config.icons")

utils.map({ ["<leader>"] = { u = { "<cmd>UndotreeToggle<cr>", icons.History .. "Undotree" } } })
