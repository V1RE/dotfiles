local wk = require("which-key")

require("harpoon").setup()

wk.register({
  ["<leader>"] = {
    h = {
      name = "Harpoon",
      t = { require("harpoon.ui").toggle_quick_menu, "Toggle quick menu" },
      a = { require("harpoon.mark").add_file, "Add file" },
    },
  },
})
