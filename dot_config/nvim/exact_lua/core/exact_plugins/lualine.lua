---@type LazyPluginSpec[]
local M = {
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    init = function()
      vim.g.gitblame_display_virtual_text = 0
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
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
        local chars = {
          "__",
          "▁▁",
          "▂▂",
          "▃▃",
          "▄▄",
          "▅▅",
          "▆▆",
          "▇▇",
          "██",
        }
        local line_ratio = current_line / total_lines
        local index = math.ceil(line_ratio * #chars)
        return chars[index]
      end

      local spaces = function()
        return "spaces: " .. vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
      end

      local fileicon = {
        "filetype",
        icon_only = true,
      }

      local filename = {
        "filename",
        path = 0,

        symbols = {
          modified = i.Circle, -- Text to show when the file is modified.
          readonly = i.Lock, -- Text to show when the file is non-modifiable or readonly.
          unnamed = "[No Name]", -- Text to show for unnamed buffers.
          newfile = "[New]", -- Text to show for new created file before first writting
        },
      }

      local winbar = {
        lualine_c = {
          fileicon,
          filename,
          { "aerial" },
        },
      }
      return {
        options = {
          icons_enabled = true,
          theme = "catppuccin",
          component_separators = "",
          section_separators = "",
          disabled_filetypes = {
            winbar = { "neo-tree", "dap-repl" },
          },
          always_divide_middle = true,
          globalstatus = true,
        },
        winbar = winbar,
        inactive_winbar = winbar,
        sections = {
          lualine_a = {
            branch,
            diagnostics,
          },
          lualine_b = { mode },
          lualine_c = { fileicon, { "filename", path = 1 } },
          lualine_x = {
            { require("gitblame").get_current_blame_text, cond = require("gitblame").is_blame_text_available },
            diff,
          },
          lualine_y = { spaces, location },
          lualine_z = { progress },
        },
        extensions = { "quickfix", "neo-tree", "aerial" },
      }
    end,
  },
}

return M
