---@type LazyPluginSpec[]
return {
  -- Swap list items
  {
    "mizlan/iswap.nvim",
    cmd = { "ISwap", "ISwapWith", "ISwapNode", "ISwapNodeWith" },
    opts = {},
  },

  -- Enhanced increment/decrement
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>", mode = { "n", "v" } },
      { "<C-x>", mode = { "n", "v" } },
      { "g<C-a>", mode = "v" },
      { "g<C-x>", mode = "v" },
    },
    config = function()
      local augend = require("dial.augend")
      local map = require("dial.map")

      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.integer.alias.binary,
          augend.constant.alias.bool,
          augend.constant.new({
            elements = { "public", "private" },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { "&&", "||" },
            word = false,
            cyclic = true,
          }),
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%H:%M:%S"],
          augend.hexcolor.new({ case = "lower" }),
          augend.semver.alias.semver,
        },
      })

      vim.keymap.set("n", "<C-a>", map.inc_normal(), { noremap = true })
      vim.keymap.set("n", "<C-x>", map.dec_normal(), { noremap = true })
      vim.keymap.set("v", "<C-a>", map.inc_visual(), { noremap = true })
      vim.keymap.set("v", "<C-x>", map.dec_visual(), { noremap = true })
      vim.keymap.set("v", "g<C-a>", map.inc_gvisual(), { noremap = true })
      vim.keymap.set("v", "g<C-x>", map.dec_gvisual(), { noremap = true })
    end,
  },

  -- Text substitution and coercion
  {
    "tpope/vim-abolish",
    event = "VeryLazy",
  },
}
