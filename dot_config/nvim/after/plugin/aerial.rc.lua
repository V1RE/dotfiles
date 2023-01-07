local aerial = require("aerial")
local i = require("config.icons")

-- Call the setup function to change the default behavior
aerial.setup({
  attach_mode = "global",
  backends = { "lsp", "treesitter", "markdown" },

  show_guides = true,

  icons = i,

  link_folds_to_tree = true,
  link_tree_to_folds = true,
  manage_folds = true,

  layout = {
    -- These control the width of the aerial window.
    -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_width and max_width can be a list of mixed types.
    -- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
    max_width = { 40, 0.2 },
    width = nil,
    min_width = 10,

    -- Determines the default direction to open the aerial window. The 'prefer'
    -- options will open the window in the other direction *if* there is a
    -- different buffer in the way of the preferred direction
    -- Enum: prefer_right, prefer_left, right, left, float
    default_direction = "float",
  },

  filter_kind = false,

  close_on_select = true,
})
