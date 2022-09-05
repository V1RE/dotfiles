local i = require("config.icons")
local cb = require("nvim-tree.config").nvim_tree_callback
local u = i.unspaced

require("nvim-tree").setup({
  open_on_setup = true,
  open_on_setup_file = true,
  hijack_cursor = true,
  hijack_netrw = true,
  disable_netrw = true,
  remove_keymaps = {
    "<TAB>",
  },
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
