---@type LazyPluginSpec[]
return {
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
      tailwind = true, -- Enable tailwind colors
    },
    enabled = false,
  },
}
