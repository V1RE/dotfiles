local i = require("config.icons")

---@type LazyPluginSpec[]
local M = {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    cmd = "Neotree",
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
    end,
    lazy = false,
    dependencies = {
      {
        "s1n7ax/nvim-window-picker",
        opts = {
          selection_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
          autoselect_one = true,
          include_current = false,
          filter_rules = {
            bo = {
              filetype = { "neo-tree", "neo-tree-popup", "notify", "noice" },
              buftype = { "terminal", "quickfix" },
            },
          },
          other_win_hl_color = "#e35e4f",
        },
      },
    },
    opts = {
      popup_border_style = "rounded",

      source_selector = {
        winbar = true,
        show_scrolled_off_parent_node = true,
        content_layout = "center",
        separator = "",
        sources = {
          {
            source = "filesystem",
            display_name = "  Files ",
          },
          {
            source = "git_status",
            display_name = "  Git ",
          },
        },
      },

      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            require("neo-tree").close_all()
          end,
        },
      },

      default_component_configs = {
        icon = {
          folder_closed = i.ClosedFolder,
          folder_open = i.OpenFolder,
          folder_empty = i.Folder,
          default = i.File,
        },
        modified = {
          symbol = "[+]",
        },
        git_status = {
          symbols = {
            added = "",
            modified = "",
            deleted = "✖",
            renamed = "",
            untracked = i.Untracked,
            ignored = i.Ignore,
            unstaged = i.Mod,
            staged = i.Add,
            conflict = i.Branch,
          },
        },
      },
      window = {
        mappings = {
          ["l"] = "open_with_window_picker",
          ["h"] = "close_node",
          ["<esc>"] = "revert_preview",
          ["a"] = { "add", config = { show_path = "relative" } },
          ["c"] = { "copy", config = { show_path = "relative" } },
          ["m"] = { "move", config = { show_path = "relative" } },
          ["H"] = "prev_source",
          ["L"] = "next_source",
          ["v"] = "open_vsplit",
        },
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
        follow_current_file = true,
        group_empty_dirs = true,
        use_libuv_file_watcher = true,
        window = {
          mappings = { ["I"] = "toggle_hidden" },
        },
      },
    },
    keys = {
      { "<leader>E", "<cmd>Neotree focus<cr>", desc = i.NeoTree .. "Focus tree" },
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = i.NeoTree .. "Toggle tree" },
    },
  },
}

return M
