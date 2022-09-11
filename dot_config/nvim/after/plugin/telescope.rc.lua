local telescope = require("telescope")
local actions = require("telescope.actions")
local themes = require("telescope.themes")
local windowpicker = require("window-picker")
local utils = require("utils")
local builtin = require("telescope.builtin")

local i = require("config.icons")

telescope.setup({
  defaults = {
    history = {
      path = vim.fn.stdpath("data") .. "/databases/telescope_history.sqlite3",
      limit = 100,
    },
    prompt_prefix = i.Telescope,
    selection_caret = i.ChevronRight,
    path_display = { "truncate" },
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",

    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
    },

    mappings = {
      i = {
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<ESC>"] = "close",
      },
      n = {
        q = actions.close,
      },
    },
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--type=file", "--hidden", "--exclude=.git", "--strip-cwd-prefix" },
    },
  },

  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
    },
    file_browser = {
      theme = "dropdown",
      hijack_netrw = false,
      path = "%:p:h",

      get_selection_window = function()
        return windowpicker.pick_window() or vim.api.nvim_get_current_win()
      end,

      mappings = {
        i = {
          ["<C-c>"] = telescope.extensions.file_browser.actions.create_from_prompt,
          ["<ESC>"] = false,
        },
      },
    },
    frecency = {
      default_workspace = "CWD",
      picker = {
        themes.get_ivy(),
      },
    },
    ["ui-select"] = {
      themes.get_cursor(),
    },
  },
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")
telescope.load_extension("refactoring")
telescope.load_extension("projects")
telescope.load_extension("file_browser")
telescope.load_extension("frecency")
telescope.load_extension("smart_history")
telescope.load_extension("harpoon")

utils.map({
  ["<leader>"] = {
    f = { telescope.extensions.frecency.frecency, i.Telescope .. "Find files" },
    F = { builtin.live_grep, i.Search .. "Find Text" },
    k = { telescope.extensions.file_browser.file_browser, i.Class .. "File Manager" },
    s = {
      name = i.Telescope .. "Search",
      C = { builtin.commands, "Commands" },
      m = { builtin.man_pages, "Man Pages" },
      R = { builtin.registers, "Registers" },
      b = { builtin.builtin, "Builtin pickers" },
      c = { builtin.colorscheme, "Colorscheme" },
      h = { builtin.help_tags, "Find Help" },
      k = { builtin.keymaps, "Keymaps" },
      r = { builtin.oldfiles, "Open Recent File" },
    },
  },
})
