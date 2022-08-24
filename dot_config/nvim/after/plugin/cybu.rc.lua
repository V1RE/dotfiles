local cybu = require("cybu")

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
  cybu.cycle(direction)
end

require("which-key").register({
  L = cycle("next"),
  H = cycle("prev"),
})
