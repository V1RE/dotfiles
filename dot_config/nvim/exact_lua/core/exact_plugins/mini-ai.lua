---@type LazyPluginSpec[]
return {
  {
    "echasnovski/mini.ai",
    version = false,
    event = "VeryLazy",
    config = function(_, opts)
      require("mini.ai").setup(opts)
    end,
  },
}
