local i = require("config.icons")

---@type LazyPluginSpec[]
local M = {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = nil,
    dependencies = {
      {
        "nvim-telescope/telescope-file-browser.nvim",
        config = function()
          require("telescope").load_extension("file_browser")
        end,
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = false,
      },
      {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
          require("telescope").load_extension("ui-select")
        end,
      },
    },
    opts = {
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
            ["<C-j>"] = require("telescope.actions").cycle_history_next,
            ["<C-k>"] = require("telescope.actions").cycle_history_prev,
            ["<C-q>"] = require("telescope.actions").send_selected_to_qflist + require("telescope.actions").open_qflist,
            ["<M-q>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
          },
          n = {
            q = require("telescope.actions").close,
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
              ["<C-c>"] = require("telescope").extensions.file_browser.actions.create_from_prompt,
              ["<ESC>"] = false,
            },
          },
        },
        ["ui-select"] = {
          require("telescope.themes").get_cursor(),
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local utils = require("utils")
      local builtin = require("telescope.builtin")
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

      telescope.setup(opts)
    end,
  },
}

return M
