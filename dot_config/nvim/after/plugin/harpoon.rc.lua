local wk = require("which-key")
local ui = require("harpoon.ui")
local mark = require("harpoon.mark")
local icons = require("config.icons")

require("harpoon").setup()

--- @param index number
local function getMarkName(index)
  local name = mark.get_marked_file_name(index)

  if name then
    return vim.fn.fnamemodify(name, ":t")
  end
  return "Mark " .. index
end

--- @param index number
local function nav_mark(index)
  return {
    function()
      ui.nav_file(index)
    end,
    getMarkName(index),
  }
end

wk.register({
  [";"] = {
    name = icons.BookMark .. "Harpoon",
    j = { ui.toggle_quick_menu, "Quick menu" },
    c = { mark.add_file, "Add mark" },
    a = nav_mark(1),
    s = nav_mark(2),
    d = nav_mark(3),
    f = nav_mark(4),
  },
})

mark.on("changed", function()
  wk.register({
    [";"] = {
      a = getMarkName(1),
      s = getMarkName(2),
      d = getMarkName(3),
      f = getMarkName(4),
    },
  })
end)
