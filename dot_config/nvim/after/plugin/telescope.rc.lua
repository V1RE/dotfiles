local telescope = require("telescope")
local actions = require("telescope.actions")
local themes = require("telescope.themes")

local i = require("config.icons")

telescope.setup({
  defaults = themes.get_ivy({
    prompt_prefix = i.Telescope,
    selection_caret = i.ChevronRight,
    path_display = { "smart" },

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
        ["<esc>"] = actions.close,
      },
    },
  }),
  pickers = {
    find_files = {
      find_command = { "fd", "--type=file", "--hidden", "--exclude=.git", "--strip-cwd-prefix" },
    },
    lsp_references = themes.get_cursor({}),
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
      initial_mode = "normal",
      mappings = {
        ["i"] = {
          ["<esc>"] = nil,
        },
      },
    },
  },
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")
telescope.load_extension("refactoring")
telescope.load_extension("projects")
telescope.load_extension("file_browser")
