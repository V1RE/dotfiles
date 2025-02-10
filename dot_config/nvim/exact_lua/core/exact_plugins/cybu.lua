local i = require("config.icons")

---@type LazyPluginSpec
return {
  "ghillb/cybu.nvim",

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
    {
      "L",
      function()
        require("cybu").cycle("next")
      end,
      desc = i.ChevronRight .. "Next buffer",
    },
    {
      "H",
      function()
        require("cybu").cycle("prev")
      end,
      desc = i.ChevronLeft .. "Previous buffer",
    },
  },
}
