local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
	return
end

local i = require("config.icons")

local setup = {
	plugins = {
		spelling = {
			enabled = true,
		},
	},
	icons = {
		breadcrumb = " ",
		separator = " ",
		group = "",
	},
	window = {
		border = "rounded",
		position = "bottom",
		winblend = 25,
	},
	layout = {
		align = "center",
	},
}

local opts = {
	mode = "n", -- NORMAL mode
	prefix = nil,
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
	["<leader>"] = {
		f = { "<cmd>Telescope find_files theme=ivy<cr>", i.Telescope .. "Find files" },
		F = { "<cmd>Telescope live_grep theme=ivy<cr>", i.Search .. "Find Text" },
		c = { "<cmd>Bdelete!<CR>", i.Close .. "Close Buffer" },
		e = { "<cmd>NvimTreeToggle<cr>", " Explorer" },
		h = { "<cmd>nohlsearch<CR>", " No Highlight" },
		q = { "<cmd>q<CR>", i.CloseAll .. "Quit" },
		w = { "<cmd>w!<CR>", " Save" },

		p = {
			name = " Packer",
			S = { "<cmd>PackerStatus<cr>", "Status" },
			c = { "<cmd>PackerCompile<cr>", "Compile" },
			i = { "<cmd>PackerInstall<cr>", "Install" },
			s = { "<cmd>PackerSync<cr>", "Sync" },
			u = { "<cmd>PackerUpdate<cr>", "Update" },
		},

		g = {
			name = " Git",
			R = { "<cmd>Gitsigns reset_buffer<cr>", "Reset Buffer" },
			b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
			c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
			d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
			g = { _LAZYGIT_TOGGLE, "Lazygit" },
			j = { "<cmd>Gitsigns next_hunk<cr>", "Next Hunk" },
			k = { "<cmd>Gitsigns prev_hunk<cr>", "Prev Hunk" },
			l = { "<cmd>Gitsigns blame_line<cr>", "Blame" },
			o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
			p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview Hunk" },
			r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset Hunk" },
			s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage Hunk" },
			u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Undo Stage Hunk" },
		},

		l = {
			name = " LSP",
			I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
			S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
			a = { "<cmd>Lspsaga range_code_action<cr>", "Code Action" },
			d = { "<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics" },
			f = { vim.lsp.buf.format, "Format" },
			i = { "<cmd>LspInfo<cr>", "Info" },
			j = { vim.lsp.diagnostic.goto_next, "Next Diagnostic" },
			k = { vim.lsp.diagnostic.goto_prev, "Prev Diagnostic" },
			l = { vim.lsp.codelens.run, "CodeLens Action" },
			q = { vim.lsp.diagnostic.set_loclist, "Quickfix" },
			r = { vim.lsp.buf.rename, "Rename" },
			s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
			w = { "<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics" },
		},
		s = {
			name = " Search",
			C = { "<cmd>Telescope commands<cr>", "Commands" },
			M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
			R = { "<cmd>Telescope registers<cr>", "Registers" },
			b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
			c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
			h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
			k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
			r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		},

		t = {
			name = " Terminal",
			f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
			h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
			v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
		},
	},

	["<C-Space>"] = { "<cmd>ToggleTerm size=15 direction=horizontal<cr>", "ToggleTerm" },

	["<Tab>"] = { "<cmd>HopWord<cr>", " Hop" },
	[";"] = { "<cmd>Telescope commands<cr>", " Commands" },

	g = {
		a = { "<cmd>Telescope lsp_code_actions<cr>", "Code actions" },
		d = { "<cmd>Telescope lsp_definitions<cr>", "Go to definition" },
	},
}

wk.setup(setup)
wk.register(mappings, opts)
