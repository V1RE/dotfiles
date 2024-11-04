---@type LazyPluginSpec
local M = {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        "lazy.nvim",
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  { -- optional cmp completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },
  -- config = function()
  --   local util = require("neodev.util")
  --   require("neodev").setup({
  --     library = {
  --       plugins = true,
  --       types = true,
  --     },
  --     override = function(root_dir, library)
  --       if util.has_file(root_dir, "~/.local/share/chezmoi") or util.has_file(root_dir, "~/.config/nvim") then
  --         library.enabled = true
  --         library.plugins = true
  --       end
  --     end,
  --   })
  -- end,
  -- enabled = false,
}

return M
