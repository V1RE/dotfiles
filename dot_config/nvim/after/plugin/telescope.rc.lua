local telescope = require("telescope")
local actions = require("telescope.actions")
local themes = require("telescope.themes")
local utils = require("utils")
local builtin = require("telescope.builtin")

local i = require("config.icons")

telescope.setup({
  defaults = {
    prompt_prefix = i.Telescope,
    selection_caret = i.ChevronRight,
    path_display = { "truncate" },
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    dynamic_preview_title = true,

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
    file_browser = {
      theme = "dropdown",
      hijack_netrw = false,
      path = "%:p:h",

      mappings = {
        i = {
          ["<C-c>"] = telescope.extensions.file_browser.actions.create_from_prompt,
          ["<ESC>"] = false,
        },
      },
    },
    ["ui-select"] = {
      themes.get_cursor(),
    },
    aerial = {
      show_nesting = {
        ["_"] = false,
        json = true,
        yaml = true,
      },
    },
  },
})

telescope.load_extension("ui-select")
telescope.load_extension("projects")
telescope.load_extension("file_browser")
telescope.load_extension("harpoon")
telescope.load_extension("aerial")

utils.map({
  ["<leader>"] = {
    f = { builtin.find_files, i.Telescope .. "Find files" },
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
    a = { builtin.buffers, i.Telescope .. "Pick Buffer" },
    b = {
      f = { builtin.buffers, i.Telescope .. "Find" },
    },
    l = {
      S = { builtin.lsp_dynamic_workspace_symbols, "Workspace Symbols" },
      s = { builtin.lsp_document_symbols, "Document Symbols" },
      w = { builtin.lsp_workspace_diagnostics, "Workspace Diagnostics" },
    },
  },

  g = {
    d = { builtin.lsp_definitions, i.Constant .. "Definition" },
    i = { builtin.lsp_implementations, i.Interface .. "Implementations" },
    r = { builtin.lsp_references, i.Reference .. "References" },
  },
})
