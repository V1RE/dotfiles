---@type LazyPluginSpec[]
local M = {
  {
    "ecthelionvi/NeoComposer.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    ---@type NeoComposer.Config
    opts = {
      keymaps = {
        toggle_macro_menu = "<leader>nm",
      },
    },
    enabled = false,
  },
}

return M

---@class NeoComposer.Colors
---@field bg string
---@field fg string
---@field red string
---@field blue string
---@field green string

---@class NeoComposer.Keymaps
---@field play_macro string
---@field yank_macro string
---@field stop_macro string
---@field toggle_record string
---@field cycle_next string
---@field cycle_prev string
---@field toggle_macro_menu string

---@class NeoComposer.Config
---@field notify boolean
---@field delay_timer number
---@field colors NeoComposer.Colors
---@field keymaps NeoComposer.Keymaps
