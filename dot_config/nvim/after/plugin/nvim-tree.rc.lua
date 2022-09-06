local i = require("config.icons")
local cb = require("nvim-tree.config").nvim_tree_callback
local u = i.unspaced

require("nvim-tree").setup({
  open_on_setup = true,
  open_on_setup_file = true,
  hijack_cursor = false,
  disable_netrw = false,
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      error = i.Error,
      hint = i.Hint,
      info = i.Information,
    },
  },
  update_focused_file = {
    enable = true,
  },
  system_open = {
    cmd = nil,
  },
  filters = {
    custom = { "\\.git$" },
  },
  view = {
    width = 40,
    mappings = {
      list = {
        { key = { "l", "<CR>", "o" }, cb = cb("edit") },
        { key = "h", cb = cb("close_node") },
        { key = "v", cb = cb("vsplit") },
        {
          key = "<tab>",
          cb = function()
            require("hop").hint_lines()
          end,
        },
      },
    },
    centralize_selection = true,
    float = {
      --[[ enable = true, ]]
      open_win_config = {
        relative = "editor",
        border = "rounded",
        width = 40,
        height = 9999,
        row = 1,
        col = 1,
      },
    },
  },
  actions = {
    remove_file = {
      close_window = false,
    },
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
    highlight_opened_files = "icon",
    icons = {
      glyphs = {
        git = {
          unstaged = u.Mod,
          staged = u.Add,
          unmerged = u.Diff,
          renamed = u.Rename,
          deleted = u.Remove,
          untracked = u.Untracked,
          ignored = u.Ignore,
        },
        folder = {
          arrow_open = u.ChevronDown,
          arrow_closed = u.ChevronRight,
        },
      },
    },
  },
})
