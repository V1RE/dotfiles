---@type LazyPluginSpec[]
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    ---@type Gitsigns.Config
    opts = {
      current_line_blame = true,
    },
  },
}
