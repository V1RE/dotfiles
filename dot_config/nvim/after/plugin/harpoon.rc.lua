local wk = require("which-key")
local ui = require("harpoon.ui")
local icons = require("config.icons")

require("harpoon").setup()

--- @param index number
local function nav_mark(index)
  return {
    function()
      ui.nav_file(index)
    end,
    "Mark " .. index,
  }
end

wk.register({
  ["<leader>"] = {
    a = {
      name = icons.BookMark .. "Harpoon",
      f = { ui.toggle_quick_menu, "Quick menu" },
      n = { require("harpoon.mark").add_file, "Add mark" },
      j = nav_mark(1),
      k = nav_mark(2),
      l = nav_mark(3),
    },
  },
})
