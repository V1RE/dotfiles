--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_functions = true
lvim.format_on_save = true
lvim.colorscheme = "onedarker"
vim.o.guifont = "FiraCode Nerd Font:h16"
vim.opt.autoread = true

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
lvim.keys.normal_mode["?"] = "<cmd>SearchBoxMatchAll clear_matches=true<cr>"
-- add your own keymapping
-- lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = ""
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
}

lvim.builtin.which_key.mappings.g["f"] = {
  "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>",
  "Switch WorkTree",
}
lvim.builtin.which_key.mappings.g["n"] = {
  "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>",
  "Create WorkTree",
}
-- lvim.builtin.which_key.mappings.q = { "<cmd>FineCmdline<cr>", "Enter Command" }
lvim.builtin.which_key.mappings.l["r"] = { "<cmd>Lspsaga rename<cr>", "Rename" }
lvim.builtin.which_key.mappings.s["s"] = { "<cmd>Lspsaga rename<cr>", "Rename" }
-- lvim.lsp.buffer_mappings.normal_mode["L"] = { "<cmd>SymbolsOutline<cr>", "Show Hover" }
lvim.lsp.buffer_mappings.normal_mode["J"] = { "<cmd>Lspsaga lsp_finder<cr>", "Show LSP Finder" }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.filters.dotfiles = false
lvim.builtin.nvimtree.setup.open_on_setup = true
lvim.builtin.nvimtree.setup.disable_netrw = true
lvim.builtin.nvimtree.setup.hijack_netrw = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.view.width = 40
lvim.builtin.nvimtree.show_icons.git = true
lvim.builtin.gitsigns.opts.current_line_blame = true
-- table.insert(lvim.builtin.nvimtree.auto_ignore_ft, "man")

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = "maintained"
lvim.builtin.treesitter.ignore_install = { "haskell", "elixir" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.rainbow.enable = true
lvim.builtin.treesitter.autotag.enable = true
lvim.lsp.automatic_servers_installation = true

lvim.builtin.telescope.defaults.pickers.find_files.find_command = { "fd", "--type=file", "--hidden" }

lvim.builtin.notify.active = true

lvim.builtin.cmp.mapping["<C-y>"] = function(fallback)
  fallback()
end

local lspconfig = require "lspconfig"
local configs = require "lspconfig.configs"

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

if not configs.ls_emmet then
  configs.ls_emmet = {
    default_config = {
      cmd = { "ls_emmet", "--stdio" },
      filetypes = {
        "html",
        "css",
        "scss",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "haml",
        "xml",
        "xsl",
        "pug",
        "slim",
        "sass",
        "stylus",
        "less",
        "sss",
      },
      root_dir = function(_)
        return vim.loop.cwd()
      end,
      settings = {},
    },
  }
end

lspconfig.ls_emmet.setup { capabilities = capabilities }

-- Additional Plugins
lvim.plugins = {
  {
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup {}
    end,
  },
  {
    "vim-test/vim-test",
  },
  {
    "ThePrimeagen/refactoring.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    config = function()
      require("git-worktree").setup {}
    end,
  },
  {
    "tami5/lspsaga.nvim",
    config = function()
      require("lsp.saga").setup()
    end,
  },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
  },
  {
    "wakatime/vim-wakatime",
  },
  {
    "christoomey/vim-tmux-navigator",
  },
  {
    "mattn/emmet-vim",
  },
  {
    "folke/tokyonight.nvim",
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup {
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
        filetype_exclude = { "dashboard", "NvimTree", "lspinfo" },
      }
    end,
  },
  {
    "andymass/vim-matchup",
    event = "CursorMoved",
  },
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "<Tab>", ":HopWord<cr>", { silent = true })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "p00f/nvim-ts-rainbow",
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "tzachar/cmp-tabnine",
    config = function()
      local tabnine = require "cmp_tabnine.config"
      tabnine:setup {
        max_lines = 1000,
        max_num_results = 20,
        sort = true,
      }
    end,

    run = "./install.sh",
    requires = "hrsh7th/nvim-cmp",
  },
  {
    "tpope/vim-surround",
  },
  {
    "VonHeikemen/searchbox.nvim",
    requires = {
      { "MunifTanjim/nui.nvim" },
    },
  },
  {
    "luukvbaal/stabilize.nvim",
    config = function()
      require("stabilize").setup()
    end,
  },
  {
    "haringsrob/nvim_context_vt",
  },
  {
    "nelsyeung/twig.vim",
  },
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
lvim.autocommands.custom_groups = {
  { "FileType", "man", "set showtabline=0" },
  { "BufNew,BufNewFile,BufRead", "*.astro", "set filetype=html" },
  { "BufNew,BufNewFile,BufRead", "*.snap", "set filetype=javascript" },
}
