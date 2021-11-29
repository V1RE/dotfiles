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
lvim.log.level = "debug"
lvim.format_on_save = true
lvim.colorscheme = "tokyonight"
vim.o.guifont = "FiraCode Nerd Font:h16"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
-- lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = ""
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- lvim.builtin.telescope.on_config_done = function()
--   local actions = require "telescope.actions"
--   -- for input mode
--   lvim.builtin.telescope.defaults.mappings.i["<C-j>"] = actions.move_selection_next
--   lvim.builtin.telescope.defaults.mappings.i["<C-k>"] = actions.move_selection_previous
--   lvim.builtin.telescope.defaults.mappings.i["<C-n>"] = actions.cycle_history_next
--   lvim.builtin.telescope.defaults.mappings.i["<C-p>"] = actions.cycle_history_prev
--   -- for normal mode
--   lvim.builtin.telescope.defaults.mappings.n["<C-j>"] = actions.move_selection_next
--   lvim.builtin.telescope.defaults.mappings.n["<C-k>"] = actions.move_selection_previous
-- end

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

lvim.builtin.which_key.mappings.l["r"] = { "<cmd>Lspsaga rename<cr>", "Rename" }
-- lvim.lsp.buffer_mappings.normal_mode["L"] = { "<cmd>SymbolsOutline<cr>", "Show Hover" }
lvim.lsp.buffer_mappings.normal_mode["J"] = { "<cmd>Lspsaga lsp_finder<cr>", "Show LSP Finder" }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.filters.dotfiles = true
lvim.builtin.nvimtree.setup.open_on_setup = true
lvim.builtin.nvimtree.setup.disable_netrw = true
lvim.builtin.nvimtree.setup.hijack_netrw = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.view.width = 40
lvim.builtin.nvimtree.show_icons.git = true
-- table.insert(lvim.builtin.nvimtree.auto_ignore_ft, "man")

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = "maintained"
lvim.builtin.treesitter.ignore_install = { "haskell", "elixir" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.rainbow.enable = true
lvim.builtin.treesitter.autotag.enable = true
lvim.lsp.automatic_servers_installation = false

lvim.builtin.notify.active = true

lvim.builtin.cmp.mapping["<C-y>"] = function(fallback)
  fallback()
end

-- Additional Plugins
lvim.plugins = {
  {
    "ThePrimeagen/harpoon",
    requires = { { "nvim-lua/plenary.nvim" } },
    config = function()
      lvim.builtin.which_key.mappings["<leader>"] = {
        "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>",
        "Open Harpoon",
      }
      lvim.builtin.which_key.mappings["a"] = { "<cmd>lua require('harpoon.mark').add_file()<CR>", "Add to Harpoon" }
      lvim.builtin.which_key.mappings["A"] = { "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", "Harpoon 1" }
      lvim.builtin.which_key.mappings["S"] = { "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", "Harpoon 2" }
      lvim.builtin.which_key.mappings["D"] = { "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", "Harpoon 3" }
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  {
    "tami5/lspsaga.nvim",
    config = function()
      require("lsp.saga").setup()
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
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup {
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
        filetype_exclude = { "dashboard", "NvimTree" },
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
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      vim.g.gitblame_enabled = 0
    end,
  },
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
lvim.autocommands.custom_groups = {
  { "FileType", "man", "set showtabline=0" },
  { "BufNew,BufNewFile,BufRead", "*.astro", "set filetype=html" },
}
