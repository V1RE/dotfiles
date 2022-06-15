local ntree_ok, ntree = pcall(require, "nvim-tree")
local ntreec_ok, ntreec = pcall(require, "nvim-tree.config")

if not (ntree_ok and ntreec_ok) then
	return
end

local i = require("config.icons")
local cb = ntreec.nvim_tree_callback
local u = i.unspaced

ntree.setup({
	open_on_setup = false,
	open_on_setup_file = false,
	hijack_netrw = false,
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
				{ key = { "l", "<CR>", "o" }, cb = cb("edit") },
				{ key = "h", cb = cb("close_node") },
				{ key = "v", cb = cb("vsplit") },
			},
		},
	},
	renderer = {
		group_empty = true,
		highlight_git = true,
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
