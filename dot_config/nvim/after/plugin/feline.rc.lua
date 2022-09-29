local navic = require("nvim-navic")

local components = {
  active = { {} },
  inactive = {},
}

table.insert(components.active[1], {
  provider = function()
    return "asdf"
    --[[ return navic.get_location() ]]
  end,
  --[[ enabled = function() ]]
  --[[   return navic.is_available() ]]
  --[[ end, ]]
})

require("feline").winbar.setup({ components = components })
