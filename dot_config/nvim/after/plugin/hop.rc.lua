local hop = require("hop")
local icons = require("config.icons")
local utils = require("utils")
local hd = require("hop.hint").HintDirection

hop.setup()

local function f()
  hop.hint_char1({
    direction = hd.AFTER_CURSOR,
  })
end

local function F()
  hop.hint_char1({
    direction = hd.BEFORE_CURSOR,
  })
end

utils.map({
  ["<TAB>"] = { hop.hint_patterns, icons.Rocket .. "Hop" },
  f = { f, "f" },
  F = { F, "F" },
})

utils.map({
  f = { f, "f" },
  F = { F, "F" },
}, "v")
