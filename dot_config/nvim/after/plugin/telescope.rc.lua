local telescope = require("telescope")
local actions = require("telescope.actions")
local themes = require("telescope.themes")
local action_set = require("telescope.actions.set")
local windowpicker = require("window-picker")

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

    get_selection_window = function()
      return windowpicker.pick_window() or vim.api.nvim_get_current_win()
    end,

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
        ["<CR>"] = function(prompt_bufnr)
          vim.pretty_print(prompt_bufnr)
          return action_set.select(prompt_bufnr, "default")
        end,
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
