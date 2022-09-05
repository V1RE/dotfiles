local i = require("config.icons")
local cb = require("nvim-tree.config").nvim_tree_callback
local u = i.unspaced

require("nvim-tree").setup({
  open_on_setup = false,
  open_on_setup_file = false,
  hijack_cursor = true,
  disable_netrw = true,
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
    float = {
      enable = true,
    },
  },
  actions = {
    remove_file = {
      close_window = false,
    },
    open_file = {
      quit_on_open = true,
    },
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
    highlight_opened_files = "name",
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
