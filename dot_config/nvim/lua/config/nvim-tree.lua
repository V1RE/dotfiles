local status_ok, nvim_tree = pcall(require, "nvim-tree")
local ok, tree_config = pcall(require, "nvim-tree.config")

if not (status_ok and ok) then
	return
end

local tree_cb = tree_config.nvim_tree_callback

local i = require("config.icons")

vim.g.nvim_tree_icons = {
	git = {
		unstaged = i.Mod:sub(1, -2),
		staged = i.Add:sub(1, -2),
		unmerged = i.Diff:sub(1, -2),
		renamed = i.Rename:sub(1, -2),
		deleted = i.Remove:sub(1, -2),
		untracked = i.Untracked:sub(1, -2),
		ignored = i.Ignore:sub(1, -2),
	},
	folder = {
		arrow_open = i.ChevronDown:sub(1, -2),
		arrow_closed = i.ChevronRight:sub(1, -2),
	},
}

vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_git_hl = 1

nvim_tree.setup({
	open_on_setup = true,
	open_on_setup_file = true,
	hijack_cursor = true,
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
				{ key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
				{ key = "h", cb = tree_cb("close_node") },
				{ key = "v", cb = tree_cb("vsplit") },
			},
		},
	},
})
