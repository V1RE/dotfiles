local wk = require("which-key")
local telescope = require("telescope.builtin")

local i = require("config.icons")

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

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
    f = { telescope.find_files, i.Telescope .. "Find files" },
    F = { telescope.live_grep, i.Search .. "Find Text" },
    e = { "<cmd>NvimTreeToggle<cr>", i.NvimTree .. "Explorer" },
    k = { "<cmd>Lf<cr>", i.Class .. "File Manager" },
    h = { "<cmd>nohlsearch<CR>", i.NoHighlight .. "Clear highlight" },

    b = {
      name = i.Buffer .. "Buffer",
      s = { "<cmd>w!<CR>", i.Save .. "Save" },
      d = { "<cmd>Bdelete<CR>", i.Close .. "Close" },
      f = { telescope.buffers, i.Telescope .. "Find" },
    },

    j = {
      name = i.Window .. "Window",
      d = { "<cmd>q<CR>", i.Close .. "Close" },
      a = { "<cmd>qa<CR>", i.CloseAll .. "Close all" },
    },

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
      b = { telescope.git_branches, "Checkout branch" },
      c = { telescope.git_commits, "Checkout commit" },
      d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
      g = { lazygit.toggle, "Lazygit" },
      j = { "<cmd>Gitsigns next_hunk<cr>", "Next Hunk" },
      k = { "<cmd>Gitsigns prev_hunk<cr>", "Prev Hunk" },
      l = { "<cmd>Gitsigns blame_line<cr>", "Blame" },
      o = { telescope.git_status, "Open changed file" },
      p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview Hunk" },
      r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset Hunk" },
      s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage Hunk" },
      u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Undo Stage Hunk" },
    },

    l = {
      name = i.Field .. "LSP",
      I = { "<cmd>Mason<cr>", "Installer Info" },
      S = { telescope.lsp_dynamic_workspace_symbols, "Workspace Symbols" },
      a = { vim.lsp.buf.code_action, "Code Action" },
      d = { require("lsp_lines").toggle, "Document Diagnostics" },
      f = { vim.lsp.buf.format, "Format" },
      i = { "<cmd>LspInfo<cr>", "Info" },
      j = { vim.lsp.diagnostic.goto_next, "Next Diagnostic" },
      k = { vim.lsp.diagnostic.goto_prev, "Prev Diagnostic" },
      l = { vim.lsp.codelens.run, "CodeLens Action" },
      q = { vim.lsp.diagnostic.set_loclist, "Quickfix" },
      r = { vim.lsp.buf.rename, "Rename" },
      s = { telescope.lsp_document_symbols, "Document Symbols" },
      w = { telescope.lsp_workspace_diagnostics, "Workspace Diagnostics" },
    },
    s = {
      name = " Search",
      C = { telescope.commands, "Commands" },
      M = { telescope.man_pages, "Man Pages" },
      R = { telescope.registers, "Registers" },
      b = { telescope.git_branches, "Checkout branch" },
      c = { telescope.colorscheme, "Colorscheme" },
      h = { telescope.help_tags, "Find Help" },
      k = { telescope.keymaps, "Keymaps" },
      r = { telescope.oldfiles, "Open Recent File" },
    },

    t = {
      name = " Terminal",
      f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
      h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
      v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
    },
  },

  ["<C-Space>"] = { "<cmd>ToggleTerm size=15 direction=float<cr>", "ToggleTerm" },

  ["<Tab>"] = { "<cmd>HopWord<cr>", " Hop" },
  [";"] = { telescope.commands, " Commands" },

  L = { "<cmd>CybuNext<cr>", i.ChevronRight .. "Next buffer" },
  H = { "<cmd>CybuPrev<cr>", i.ChevronLeft .. "Previouw buffer" },

  K = { vim.lsp.buf.hover, i.Comment .. "Hover" },

  g = {
    name = i.Goto .. "Go to",
    a = { vim.lsp.buf.range_code_action, i.Event .. "Code actions" },
    d = { telescope.lsp_definitions, i.Constant .. "Definition" },
    i = { telescope.lsp_implementations, i.Interface .. "Implementations" },
    r = { telescope.lsp_references, i.Reference .. "References" },
    l = { vim.diagnostic.open_float, i.Warning .. "Diagnostics" },
  },
}

wk.setup(setup)
wk.register(mappings, opts)
