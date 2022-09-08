local wk = require("which-key")
local ui = require("harpoon.ui")

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
      name = "Harpoon",
      t = { ui.toggle_quick_menu, "Toggle quick menu" },
      n = { require("harpoon.mark").add_file, "Add file" },
      j = nav_mark(1),
      k = nav_mark(2),
      l = nav_mark(3),
    },
  },
})
