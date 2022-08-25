local i = require("config.icons")

require("bufferline").setup({
  options = {
    numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
    close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
    right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
    buffer_close_icon = i.Close,
    modified_icon = i.Circle,
    close_icon = i.CloseAll,
    max_name_length = 30,
    max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
    tab_size = 21,
    diagnostics = "nvim_lsp", -- | "nvim_lsp" | "coc",
    offsets = {
      { filetype = "NvimTree", text = i.NvimTree .. "Files", padding = 1 },
    },
    separator_style = "thick", -- | "thick" | "thin" | { 'any', 'any' },
    enforce_regular_tabs = true,
  },
})
