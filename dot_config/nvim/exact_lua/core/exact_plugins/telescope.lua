---@diagnostic disable: missing-fields
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
        keys = {
          {
            "<leader>K",
            function()
              require("telescope").extensions.file_browser.file_browser({
                cwd = require("telescope.utils").buffer_dir(),
              })
            end,
            desc = i.Class .. "File manager",
          },
        },
      },
      {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
          require("telescope").load_extension("ui-select")
        end,
      },
      {
        "nvim-telescope/telescope-media-files.nvim",
        config = function()
          require("telescope").load_extension("media_files")
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
            ["<C-j>"] = function(...)
              require("telescope.actions").cycle_history_next(...)
            end,
            ["<C-k>"] = function(...)
              require("telescope.actions").cycle_history_prev(...)
            end,
            ["<C-q>"] = function(...)
              require("telescope.actions").send_selected_to_qflist(...)
              require("telescope.actions").open_qflist(...)
            end,
            ["<M-q>"] = function(...)
              require("telescope.actions").send_to_qflist(...)
              require("telescope.actions").open_qflist(...)
            end,
          },
          n = {
            q = function(...)
              require("telescope.actions").close(...)
            end,
          },
        },
      },
      pickers = {
        find_files = {
          find_command = { "fd", "--type=file", "--hidden", "--exclude=.git", "--strip-cwd-prefix" },
          hidden = true,
        },
      },

      extensions = {
        file_browser = {
          theme = "dropdown",
          hijack_netrw = false,
          path = "%:p:h",

          mappings = {
            i = {
              -- ["<C-c>"] = require("telescope").extensions.file_browser.actions.create_from_prompt,
              ["<ESC>"] = false,
            },
          },
        },
        ["ui-select"] = {
          -- require("telescope.themes").get_cursor(),
        },
        media_files = {
          -- filetypes whitelist
          -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
          filetypes = { "png", "webp", "jpg", "jpeg", "svg", "mp4", "pdf" },
        },
      },
    },
    keys = {
      { "<leader><leader>", "<cmd>Telescope resume<cr>", desc = i.Watch .. "Resume Telescope" },
      {
        "<leader>f",
        function()
          require("telescope.builtin").find_files({ hidden = true })
        end,
        desc = i.Telescope .. "Find files",
      },
      { "<leader>F", "<cmd>Telescope live_grep<cr>", desc = i.Search .. "Find text" },
      {
        "<leader>k",
        function()
          require("telescope.builtin").find_files({ cwd = require("telescope.utils").buffer_dir() })
        end,
        desc = i.Telescope .. "Find files cwd",
      },

      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sm", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>sb", "<cmd>Telescope builtin<cr>", desc = "Builtin pickers" },
      { "<leader>sc", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Find Help" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },

      { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = i.Constant .. "Definition" },
      { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = i.Interface .. "Implementations" },
      { "gr", "<cmd>Telescope lsp_references<cr>", desc = i.Reference .. "References" },

      { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
      { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<leader>lw", "<cmd>Telescope lsp_workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
    },
  },
}

return M
