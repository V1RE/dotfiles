---@type LazyPluginSpec[]
return {
  -- Better buffer deletion
  {
    "famiu/bufdelete.nvim",
    cmd = { "Bdelete", "Bwipeout" },
  },

  -- Alternative buffer deletion
  {
    "moll/vim-bbye",
    cmd = { "Bdelete", "Bwipeout" },
  },

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
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
        },
      })

      vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
      vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
      vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
      vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
      vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true })
      vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true })
    end,
  },

  -- Text substitution and coercion
  {
    "tpope/vim-abolish",
    event = "VeryLazy",
  },
}
