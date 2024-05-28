---@type LazyPluginSpec[]
local M = {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",

    dependencies = {
      { "nvim-treesitter/nvim-treesitter-context", config = true },
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "nvim-treesitter/playground" },
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        init = function()
          vim.g.skip_ts_context_commentstring_module = true
        end,
      },
    },

    ---@type TSConfig
    opts = {
      ensure_installed = "all", -- one of "all", or a list of languages
      sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
      ignore_install = { "haskell", "elixir", "phpdoc" }, -- List of parsers to ignore installing
      playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
      },
      highlight = { enable = true },
      indent = { enable = true },
      context_commentstring = { enable = true, enable_autocmd = false },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<Enter>",
          node_incremental = "<Enter>",
          node_decremental = "<BS>",
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    config = true
  },
}

return M
