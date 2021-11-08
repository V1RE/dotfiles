--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"
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

lvim.lsp.templates_dir = join_paths(get_config_dir(), "ftplugin")

lvim.builtin.which_key.mappings.l["r"] = { "<cmd>Lspsaga rename<cr>", "Rename" }
-- lvim.lsp.buffer_mappings.normal_mode["K"] = { "<cmd>Lspsaga hover_doc<cr>", "Show Hover" }
lvim.lsp.buffer_mappings.normal_mode["J"] = { "<cmd>Lspsaga lsp_finder<cr>", "Show LSP Finder" }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.hide_dotfiles = 0
lvim.builtin.nvimtree.setup.auto_open = 1
lvim.builtin.nvimtree.setup.disable_netrw = 1
lvim.builtin.nvimtree.setup.hijack_netrw = 1
lvim.builtin.nvimtree.setup.open_on_setup = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.view.width = 40
lvim.builtin.nvimtree.show_icons.git = 1
table.insert(lvim.builtin.nvimtree.auto_ignore_ft, "man")

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = "maintained"
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.rainbow.enable = true
lvim.builtin.treesitter.autotag.enable = true
lvim.lsp.automatic_servers_installation = false

lvim.builtin.notify.active = true

lvim.builtin.cmp.mapping["<C-y>"] = function(fallback)
  fallback()
end

lvim.lang.json.formatters = { { exe = "prettier" } }
lvim.lang.yaml.formatters = { { exe = "prettier" } }
lvim.lang.html.formatters = { { exe = "prettier" } }
lvim.lang.typescript.linters = { { exe = "eslint_d" } }
lvim.lang.typescript.formatters = { { exe = "eslint_d" } }
lvim.lang.lua.formatters = { { exe = "stylua" } }
lvim.lang.lua.linters = { { exe = "luacheck" } }
lvim.lang.sh.linters = { { exe = "shellcheck" } }
lvim.lang.sh.formatters = { { exe = "shfmt" } }
lvim.lang.rust.formatters = { { exe = "rustfmt" } }
lvim.lang.php.linters = { { exe = "phpstan" } }
-- lvim.lang.php.formatters = {
--   {
--     exe = "phpcsfixer",
--     args = { "--no-interaction", "--config=./app/public/.php-cs-fixer.php", "--quiet", "fix", "$FILENAME" },
--   },
-- }
lvim.lang.scss.linters = { { exe = "stylelint" } }
lvim.lang.scss.formatters = { { exe = "stylelint" } }

-- generic LSP settings
-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
function Register_package_manager_keys()
  local keys = {
    ["Cargo.toml"] = {
      t = { "<cmd>lua require('crates').toggle()<cr>", "Toggle visibility" },
      r = { "<cmd>lua require('crates').reload()<cr>", "Reload" },
      u = { "<cmd>lua require('crates').update_crate()<cr>", "Update package" },
      a = { "<cmd>lua require('crates').update_all_crates()<cr>", "Update all packages" },
      U = { "<cmd>lua require('crates').upgrade_crate()<cr>", "Upgrade package" },
      A = { "<cmd>lua require('crates').upgrade_all_crates()<cr>", "Upgrade all packages" },
    },
    ["package.json"] = {
      s = { "<cmd>lua require('package-info').show()<CR>", "Show package versions" },
      c = { "<cmd>lua require('package-info').hide()<CR>", "Hide package versions" },
      u = { "<cmd>lua require('package-info').update()<CR>", "Update package on line" },
      d = { "<cmd>lua require('package-info').delete()<CR>", "Delete package on line" },
      i = { "<cmd>lua require('package-info').install()<CR>", "Install a new package" },
      r = { "<cmd>lua require('package-info').reinstall()<CR>", "Reinstall dependencies" },
      p = { "<cmd>lua require('package-info').change_version()<CR>", "Install a different package version" },
    },
  }
  local filename = vim.fn.expand "%:t"
  local bufkeys = keys[filename]

  local status_ok, wk = pcall(require, "which-key")
  if not status_ok or bufkeys == nil then
    return
  end

  bufkeys["name"] = "Packages"

  wk.register({ l = { v = bufkeys } }, { mode = "n", prefix = "<leader>", buffer = 0 })
end

-- Additional Plugins
lvim.plugins = {
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
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    requires = { { "nvim-lua/plenary.nvim" } },
    config = function()
      require("crates").setup()
    end,
  },
  {
    "vuki656/package-info.nvim",
    requires = "MunifTanjim/nui.nvim",
    event = { "BufRead package.json" },
  },
  {
    "tpope/vim-surround",
    keys = { "c", "d", "y" },
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
  { "BufWinEnter", "*", "lua Register_package_manager_keys()" },
  { "BufNew,BufNewFile,BufRead", "*.astro", "set filetype=html" },
}
