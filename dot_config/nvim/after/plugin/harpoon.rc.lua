local wk = require("which-key")
local ui = require("harpoon.ui")
local icons = require("config.icons")

require("harpoon").setup()

-- vim.pretty_print(vim.fn.fnamemodify(require("harpoon.mark").get_marked_file_name(1), ":t"))
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
  [";"] = {
    name = icons.BookMark .. "Harpoon",
    j = { ui.toggle_quick_menu, "Quick menu" },
    c = { require("harpoon.mark").add_file, "Add mark" },
    a = nav_mark(1),
    s = nav_mark(2),
    d = nav_mark(3),
    f = nav_mark(4),
  },
})
