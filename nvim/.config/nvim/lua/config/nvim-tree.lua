local i = require("config.icons")

vim.g.nvim_tree_icons = {
  default = i.documents.File,
  symlink = i.documents.SymlinkFile,
  git = {
    unstaged = i.git.Mod,
    staged = i.git.Add,
    unmerged = i.git.Diff,
    renamed = i.git.Rename,
    deleted = i.git.Remove,
    untracked = i.git.Untracked,
    ignored = i.git.Ignore,
  },
  folder = {
    arrow_open = i.arrows.ChevronDown,
    arrow_closed = i.arrows.ChevronRight,
    default = i.documents.Folder,
    open = i.documents.OpenFolder,
    empty = i.documents.Folder,
    empty_open = i.documents.OpenFolder,
    symlink = i.documents.SymlinkFolder,
  },
  lsp = {
    error = i.diagnostics.Error,
    warn = i.diagnostics.Warning,
    hint = i.diagnostics.Hint,
    info = i.diagnostics.Information,
  },
}

vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_git_hl = 1

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup({
  auto_reload_on_write = true,
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  actions = {
    change_dir = {
      global = false,
    },
    open_file = {
      quit_on_open = false,
    },
  },
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = true,
  ignore_ft_on_setup = {
    "startify",
    "dashboard",
  },
  open_on_tab = false,
  hijack_cursor = true,
  update_cwd = false,
  update_to_buf_dir = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = true,
    icons = {
      error = i.diagnostics.Error,
      warn = i.diagnostics.Warning,
      hint = i.diagnostics.Hint,
      info = i.diagnostics.Information,
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = false,
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  filters = {
    dotfiles = false,
    custom = { "\\.git$" },
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    width = 40,
    height = 30,
    is_visible = true,
    hide_root_folder = false,
    side = "left",
    auto_resize = false,
    mappings = {
      custom_only = false,
      list = {
        { key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
        { key = "h", cb = tree_cb("close_node") },
        { key = "v", cb = tree_cb("vsplit") },
      },
    },
    number = false,
    relativenumber = false,
    signcolumn = "yes",
  },
  renderer = {
    indent_markers = {
      enable = false,
    },
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
})
