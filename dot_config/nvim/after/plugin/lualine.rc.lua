local navic = require("nvim-navic")
local i = require("config.icons")

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = {
    error = i.Error,
    warn = i.Warning,
  },
  colored = false,
  update_in_insert = false,
  always_visible = true,
}

local diff = {
  "diff",
  colored = false,
  symbols = {
    added = i.Add,
    modified = i.Mod,
    removed = i.Remove,
  }, -- changes diff symbols
  cond = hide_in_width,
}

local mode = {
  "mode",
  fmt = function(str)
    local modes = {
      INSERT = "",
      ["O-PENDING"] = "",
      NORMAL = "",
      VISUAL = "",
      ["V-LINE"] = "",
      ["V-BLOCK"] = "",
      SELECT = "",
      ["S-LINE"] = "",
      ["S-BLOCK"] = "",
      REPLACE = "",
      ["V-REPLACE"] = "",
      COMMAND = "",
      EX = "",
      MORE = "",
      CONFIRM = "",
      SHELL = "",
      TERMINAL = "",
    }
    return "     " .. modes[str] .. " "
  end,
}

local filetype = {
  "filetype",
  icons_enabled = true,
  icon = nil,
}

local branch = {
  "branch",
  icons_enabled = true,
  icon = i.Branch,
}

local location = {
  "location",
}

-- cool function for progress
local progress = function()
  local current_line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")
  local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
  local line_ratio = current_line / total_lines
  local index = math.ceil(line_ratio * #chars)
  return chars[index]
end

local spaces = function()
  return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "catppuccin",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = {
      branch,
      diagnostics,
    },
    lualine_b = { mode },
    lualine_c = { "filename", { navic.get_location, cond = navic.is_available } },
    lualine_x = { diff, spaces, "encoding", filetype },
    lualine_y = { location },
    lualine_z = { progress },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { "nvim-tree", "quickfix", "toggleterm" },
})
