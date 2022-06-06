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
		b = {
			function()
				require("telescope").extensions.file_browser.file_browser(
					require("telescope.themes").get_ivy({ previewer = false })
				)
			end,
			" Buffers",
		},
		e = { "<cmd>NvimTreeToggle<cr>", " Explorer" },
		w = { "<cmd>w!<CR>", " Save" },
		q = { "<cmd>q<CR>", " Quit" },
		c = { "<cmd>Bdelete!<CR>", " Close Buffer" },
		h = { "<cmd>nohlsearch<CR>", " No Highlight" },
		f = {
			function()
				require("telescope.builtin").find_files(require("telescope.themes").get_ivy())
			end,
			" Find files",
		},
		F = { "<cmd>Telescope live_grep theme=ivy<cr>", " Find Text" },
		P = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", " Projects" },

		p = {
			name = " Packer",
			c = { "<cmd>PackerCompile<cr>", "Compile" },
			i = { "<cmd>PackerInstall<cr>", "Install" },
			s = { "<cmd>PackerSync<cr>", "Sync" },
			S = { "<cmd>PackerStatus<cr>", "Status" },
			u = { "<cmd>PackerUpdate<cr>", "Update" },
		},

		g = {
			name = " Git",
			g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
			j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
			k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
			l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
			p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
			r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
			R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
			s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
			u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
			o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
			b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
			c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
			d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
		},

		l = {
			name = " LSP",
			a = { "<cmd>Lspsaga range_code_action<cr>", "Code Action" },
			d = { "<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics" },
			w = { "<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics" },
			f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format" },
			i = { "<cmd>LspInfo<cr>", "Info" },
			I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
			j = { "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", "Next Diagnostic" },
			k = { "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
			l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
			q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
			r = { "<cmd>Lspsaga rename<cr>", "Rename" },
			s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
			S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
		},
		s = {
			name = " Search",
			b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
			c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
			h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
			M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
			r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
			R = { "<cmd>Telescope registers<cr>", "Registers" },
			k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
			C = { "<cmd>Telescope commands<cr>", "Commands" },
		},

		t = {
			name = " Terminal",
			n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
			u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
			t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
			p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
			f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
			h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
			v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
		},
	},

	["<C-Space>"] = { "<cmd>ToggleTerm size=15 direction=horizontal<cr>", "ToggleTerm" },

	["<Tab>"] = { "<cmd>HopWord<cr>", " Hop" },
	[";"] = { "<cmd>Telescope commands<cr>", " Commands" },

	g = {
		d = { "<cmd>Telescope lsp_definitions<cr>", "Go to definition" },
		a = { "<cmd>Telescope lsp_code_actions<cr>", "Code actions" },
	},
}

wk.setup(setup)
wk.register(mappings, opts)
