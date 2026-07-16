local i = require("config.icons")

---@type LazyPluginSpec
return {
  "ghillb/cybu.nvim",
  branch = "v1.x",
  dependencies = { "nvim-lua/plenary.nvim" },

  ---@type CybuOptions
  opts = {
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
  },

  keys = {
    { "L", "<Plug>(CybuNext)", desc = i.ChevronRight .. "Next buffer" },
    { "H", "<Plug>(CybuPrev)", desc = i.ChevronLeft .. "Previous buffer" },
  },
}
