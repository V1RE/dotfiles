---@type LazyPluginSpec[]
return {
  {
    "nvim-mini/mini.surround",
    version = false,
    main = "mini.surround",
    keys = {
      { "gza", mode = { "n", "x" }, desc = "Add surrounding" },
      { "gzd", desc = "Delete surrounding" },
      { "gzf", desc = "Find right surrounding" },
      { "gzF", desc = "Find left surrounding" },
      { "gzh", desc = "Highlight surrounding" },
      { "gzr", desc = "Replace surrounding" },
      {
        "gzn",
        function()
          require("mini.surround").update_n_lines()
        end,
        desc = "Update surrounding search lines",
      },
    },
    opts = {
      mappings = {
        add = "gza",
        delete = "gzd",
        find = "gzf",
        find_left = "gzF",
        highlight = "gzh",
        replace = "gzr",
      },
    },
  },
  {
    "nvim-mini/mini.cursorword",
    version = false,
    event = "VeryLazy",
    main = "mini.cursorword",
    opts = {},
  },
}
