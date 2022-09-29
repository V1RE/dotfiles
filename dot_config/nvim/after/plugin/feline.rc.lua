local navic = require("nvim-navic")

local components = {
  active = {},
  inactive = {},
}

table.insert(components.active, {
  provider = function()
    return navic.get_location()
  end,
  enabled = function()
    return navic.is_available()
  end,
})

require("feline").winbar.setup({ components = components })