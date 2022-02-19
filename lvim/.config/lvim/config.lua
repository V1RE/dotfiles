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
vim.g.undotree_SplitWidth = 60

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
-- lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = ""
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

lvim.builtin.which_key.mappings.c = { "<cmd>Bdelete<cr>", "Close Buffer" }
lvim.builtin.which_key.mappings.u = { "<cmd>UndotreeToggle<cr><cmd>UndotreeFocus<cr>", "Toggle Undotree" }
lvim.builtin.which_key.mappings.l["r"] = { "<cmd>Lspsaga rename<cr>", "Rename" }
lvim.builtin.which_key.mappings.s["s"] = { "<cmd>Lspsaga rename<cr>", "Rename" }
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
lvim.builtin.nvimtree.setup.auto_close = true
-- table.insert(lvim.builtin.nvimtree.auto_ignore_ft, "man")

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = "maintained"
lvim.builtin.treesitter.ignore_install = { "haskell", "elixir" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.rainbow.enable = true
lvim.builtin.treesitter.autotag.enable = true
lvim.lsp.automatic_servers_installation = true

lvim.builtin.telescope.defaults.pickers.find_files.find_command = { "fd", "--type=file", "--hidden" }
lvim.builtin.telescope.defaults.mappings.i["<esc>"] = require("telescope.actions").close

lvim.builtin.notify.active = true

lvim.builtin.bufferline.options.always_show_bufferline = true

lvim.builtin.cmp.mapping["<C-y>"] = function(fallback)
  fallback()
end

vim.cmd([[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]])

-- Additional Plugins
lvim.plugins = {
  {
    "edluffy/specs.nvim",
    config = function()
      require("specs").setup({})
    end,
  },
  {
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup({})
    end,
  },
  {
    "mbbill/undotree",
  },
  {
    "moll/vim-bbye",
  },
  {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("lsp_signature").setup({})
    end,
  },
  { "kevinhwang91/nvim-bqf", ft = "qf" },
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
      require("user.lsp-saga").setup()
    end,
  },
  {
    "SmiteshP/nvim-gps",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      local gps = require("nvim-gps")
      gps.setup({})
    end,
  },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({
        text = {
          spinner = "dots_snake",
        },
      })
    end,
  },
  {
    "wakatime/vim-wakatime",
  },
  { "kevinhwang91/nvim-hlslens" },
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
      require("colorizer").setup({ "*" }, {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup({
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
        space_char_highlight_list = {
          "IndentBlanklineIndent1",
          "IndentBlanklineIndent2",
          "IndentBlanklineIndent3",
          "IndentBlanklineIndent4",
          "IndentBlanklineIndent5",
          "IndentBlanklineIndent6",
        },
        use_treesitter = true,
        filetype_exclude = { "toggleterm", "dashboard", "NvimTree", "lspinfo" },
      })
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
    "tzachar/cmp-tabnine",
    config = function()
      local tabnine = require("cmp_tabnine.config")
      tabnine:setup({
        max_lines = 1000,
        max_num_results = 20,
        sort = true,
      })
    end,

    run = "./install.sh",
    requires = "hrsh7th/nvim-cmp",
  },
  {
    "tpope/vim-surround",
  },
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
lvim.autocommands.custom_groups = {
  { "FileType", "man", "set showtabline=0" },
  { "BufNew,BufNewFile,BufRead", "*.astro", "set filetype=html" },
  { "BufNew,BufNewFile,BufRead", "*.snap", "set filetype=javascript" },
  { "BufNew,BufNewFile,BufRead", "Podfile", "set filetype=ruby" },
  { "VimEnter,WinEnter,BufWinEnter", "*\\(^NvimTree\\)\\@<!", "setlocal cursorline" },
  { "WinLeave", "*\\(^NvimTree\\)\\@<!", "setlocal nocursorline" },
}
