local lualine_ok, lualine = pcall(require, "lualine")
local gps_ok, gps = pcall(require, "nvim-gps")
if not (lualine_ok and gps_ok) then
	return
end

local i = require("config.icons")

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local tree_spacing = function()
	local tree_ok, tree = pcall(require, "nvim-tree.view")
	if not tree_ok then
		return ""
	end

	local is_visible = tree.is_visible()
	if not is_visible then
		return ""
	end

	local a_ok, a = pcall(string.rep, " ", vim.api.nvim_win_get_width(tree.get_winnr()) - 2)
	if not a_ok then
		return ""
	end

	return a
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = {
		error = i.Error,
		warn = i.Warning,
	},
	colored = false,
	update_in_insert = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = false,
	symbols = {
		added = i.Add,
		modified = i.Mod,
		removed = i.Remove,
	}, -- changes diff symbols
	cond = hide_in_width,
}

local mode = {
	"mode",
	fmt = function(str)
		local modes = {
			INSERT = "",
			["O-PENDING"] = "",
			NORMAL = "",
			VISUAL = "",
			["V-LINE"] = "",
			["V-BLOCK"] = "",
			SELECT = "",
			["S-LINE"] = "",
			["S-BLOCK"] = "",
			REPLACE = "",
			["V-REPLACE"] = "",
			COMMAND = "",
			EX = "",
			MORE = "",
			CONFIRM = "",
			SHELL = "",
			TERMINAL = "",
		}
		return "     " .. modes[str] .. " "
	end,
}

local filetype = {
	"filetype",
	icons_enabled = true,
	icon = nil,
}

local branch = {
	"branch",
	icons_enabled = true,
	icon = i.Branch,
}

local location = {
	"location",
}

local nvim_gps = function()
	local gps_location = gps.get_location()
	if gps_location == "error" then
		return ""
	else
		return gps.get_location()
	end
end

-- cool function for progress
local progress = function()
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
	local line_ratio = current_line / total_lines
	local index = math.ceil(line_ratio * #chars)
	return chars[index]
end

local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {},
		always_divide_middle = true,
		globalstatus = true,
	},
	sections = {
		lualine_a = {
			tree_spacing,
		},
		lualine_b = {
			branch,
			diagnostics,
		},
		lualine_c = { mode },
		lualine_d = { "filename", nvim_gps },
		-- lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_x = { diff, spaces, "encoding", filetype },
		lualine_y = { location },
		lualine_z = { progress },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = { "nvim-tree", "quickfix", "toggleterm" },
})
