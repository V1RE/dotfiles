local navic = require("nvim-navic")

local get_gps = function()
  local status_ok, gps_location = pcall(navic.get_location, {})
  if not status_ok then
    return ""
  end

  if not navic.is_available() or gps_location == "error" then
    return ""
  end

  if gps_location and gps_location ~= "" then
    return " " .. require("config.icons").ChevronRight .. " " .. gps_location
  else
    return ""
  end
end

require("incline").setup({
  debounce_threshold = {
    falling = 50,
    rising = 10,
  },
  hide = {
    cursorline = true,
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

    local gps = get_gps()

    return {
      { icon, guifg = color },
      { " " },
      { filename },
      { gps },
    }
  end,
  window = {
    margin = {
      horizontal = 0,
      vertical = 0,
    },
    options = {
      signcolumn = "yes",
      wrap = false,
    },
    padding = 0,
    padding_char = " ",
    placement = {
      horizontal = "left",
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
