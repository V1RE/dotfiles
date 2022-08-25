require("incline").setup({
  debounce_threshold = {
    falling = 50,
    rising = 10,
  },
  hide = {
    cursorline = false,
    focused_win = false,
    only_win = false,
  },
  highlight = {
    groups = {
      InclineNormal = {
        default = true,
        group = "NormalFloat",
      },
      InclineNormalNC = {
        default = true,
        group = "NormalFloat",
      },
    },
  },
  ignore = {
    buftypes = "special",
    filetypes = {},
    floating_wins = true,
    unlisted_buffers = true,
    wintypes = "special",
  },
  render = function(props)
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
    local icon, color = require("nvim-web-devicons").get_icon_color(filename)
    return {
      { icon, guifg = color },
      { " " },
      { filename },
    }
  end,
  window = {
    margin = {
      horizontal = 1,
      vertical = 0,
    },
    options = {
      signcolumn = "no",
      wrap = false,
    },
    padding = 1,
    padding_char = " ",
    placement = {
      horizontal = "right",
      vertical = "top",
    },
    width = "fit",
    winhighlight = {
      active = {
        EndOfBuffer = "None",
        Normal = "InclineNormal",
        Search = "None",
      },
      inactive = {
        EndOfBuffer = "None",
        Normal = "InclineNormalNC",
        Search = "None",
      },
    },
    zindex = 50,
  },
})
