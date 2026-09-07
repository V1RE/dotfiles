---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    lazy = false,
    main = "nvim-treesitter.configs",

    init = function()
      vim.treesitter.query.add_predicate("is-mise?", function(_, _, bufnr)
        local filepath = vim.fs.normalize(vim.api.nvim_buf_get_name(tonumber(bufnr) or 0))
        local filename = vim.fn.fnamemodify(filepath, ":t")
        return filename:match("^%.?mise.*%.toml$") ~= nil
          or filepath:match("/%.?mise/config%.toml$") ~= nil
          or filepath:match("/%.?mise/config%.[^/]+%.toml$") ~= nil
          or filepath:match("/%.?mise/conf%.d/[^/]+%.toml$") ~= nil
      end, { force = true, all = false })
    end,

    dependencies = {
      { "nvim-treesitter/nvim-treesitter-context", config = true },
    },

    ---@type TSConfig
    opts = {
      modules = {},
      auto_install = true,
      ensure_installed = {
        "bash",
        "css",
        "csv",
        "diff",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "graphql",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "kdl",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "query",
        "regex",
        "ruby",
        "scss",
        "sql",
        "svelte",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
      ignore_install = { "haskell", "elixir", "phpdoc" }, -- List of parsers to ignore installing
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<Enter>",
          node_incremental = "<Enter>",
          node_decremental = "<BS>",
        },
      },
    },
  },

  {
    "jmbuhr/otter.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "toml",
        group = vim.api.nvim_create_augroup("EmbedToml", { clear = true }),
        callback = function()
          require("otter").activate()
        end,
      })
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },
}
