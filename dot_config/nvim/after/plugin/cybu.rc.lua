local cybu = require("cybu")
local i = require("config.icons")

cybu.setup({
  position = {
    relative_to = "editor",
    anchor = "center",
    max_win_height = 7,
  },
  style = {
    border = "rounded",
    path = "tail",
    padding = 2,
    hide_buffer_id = true,
  },
  exclude = {
    "neo-tree",
    "fugitive",
    "qf",
    "NvimTree",
    "alpha",
  },
})

local function cycle(direction)
  return function()
    cybu.cycle(direction)
  end
end

require("which-key").register({
  L = { cycle("next"), i.ChevronRight .. "Next buffer" },
  H = { cycle("prev"), i.ChevronLeft .. "Previouw buffer" },
})
