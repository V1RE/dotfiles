local i = require("config.icons")

---@type LazyPluginSpec[]
local M = {
  {
    "s1n7ax/nvim-window-picker",
    config = true,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    cmd = "Neotree",
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      vim.cmd([[
        augroup NEOTREE_AUGROUP
          autocmd!
          au VimEnter * lua vim.defer_fn(function() vim.cmd("Neotree show left") end, 10)
        augroup END
      ]])
    end,
    opts = {
      popup_border_style = "rounded",

      source_selector = {
        winbar = true,
        show_scrolled_off_parent_node = true,
        content_layout = "center",
        separator = "",
        sources = { -- table
          {
            source = "filesystem", -- string
            display_name = "  Files ", -- string | nil
          },
          {
            source = "git_status", -- string
            display_name = "  Git ", -- string | nil
          },
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
          ["I"] = "toggle_hidden",
        },
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
        follow_current_file = true,
        group_empty_dirs = true,
        use_libuv_file_watcher = true,
      },
    },
    keys = {
      { "<leader>e", "<cmd>Neotree focus<cr>", desc = i.NeoTree .. "Focus tree" },
      { "<leader>E", "<cmd>Neotree toggle<cr>", desc = i.NeoTree .. "Toggle tree" },
    },
  },
}

return M
