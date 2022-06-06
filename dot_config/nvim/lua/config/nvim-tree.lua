local status_ok, nvim_tree = pcall(require, "nvim-tree")
local ok, tree_config = pcall(require, "nvim-tree.config")

if not (status_ok and ok) then
	return
end

local tree_cb = tree_config.nvim_tree_callback

local i = require("config.icons")

vim.g.nvim_tree_icons = {
	git = {
		unstaged = i.git.Mod:sub(1, -2),
		staged = i.git.Add:sub(1, -2),
		unmerged = i.git.Diff:sub(1, -2),
		renamed = i.git.Rename:sub(1, -2),
		deleted = i.git.Remove:sub(1, -2),
		untracked = i.git.Untracked:sub(1, -2),
		ignored = i.git.Ignore:sub(1, -2),
	},
	folder = {
		arrow_open = i.arrows.ChevronDown:sub(1, -2),
		arrow_closed = i.arrows.ChevronRight:sub(1, -2),
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
			error = i.diagnostics.Error,
			hint = i.diagnostics.Hint,
			info = i.diagnostics.Information,
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
