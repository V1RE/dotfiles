require("nvim-treesitter.configs").setup({
  ensure_installed = "all", -- one of "all", or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "haskell", "elixir", "phpdoc" }, -- List of parsers to ignore installing
  autopairs = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = true,
    disable = { "yaml" },
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
})
