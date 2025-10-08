---@type LazyPluginSpec[]
return {
  -- UI library for Neovim plugins
  { "MunifTanjim/nui.nvim" },

  -- LSP progress notifications
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Stabilize window on open
  {
    "luukvbaal/stabilize.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
