---@type LazyPluginSpec[]
local M = {
  {
    "giusgad/pets.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "giusgad/hologram.nvim" },
    config = function()
      require("pets").setup({
        speed_multiplier = 1, -- you can make your pet move faster/slower. If slower the animation will have lower fps.
        default_pet = "dog", -- the pet to use for the PetNew command
        default_style = "brown", -- the style of the pet to use for the PetNew command
        popup = {
          width = "30%", -- can be a string with percentage like "45%" or a number of columns like 45
          winblend = 0, -- winblend value - see :h 'winblend' - only used if avoid_statusline is false
          hl = { Normal = "Normal" }, -- hl is only set if avoid_statusline is true, you can put any hl group instead of "Normal"
          avoid_statusline = true, -- if winblend is 100 then the popup is invisible and covers the statusline, if that
        },
      })
    end,
  },
}

return M
