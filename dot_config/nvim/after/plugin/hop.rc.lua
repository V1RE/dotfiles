local hop = require("hop")
local icons = require("config.icons")
local utils = require("utils")
local hd = require("hop.hint").HintDirection

hop.setup()

local function f()
  hop.hint_char1({
    direction = hd.AFTER_CURSOR,
    current_line_only = true,
  })
end

utils.map({
  ["<TAB>"] = { hop.hint_words, icons.Rocket .. "Hop" },
  f = { f, "lol" },
})
