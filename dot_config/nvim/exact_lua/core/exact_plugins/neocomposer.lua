-- ---@class NeoComposer
--
-- ---@class NeoComposer.Colors
-- ---@field bg string
-- ---@field fg string
-- ---@field red string
--     blue = "#5fb3b3",
--     green = "#99c794",
--
-- ---@class NeoComposer.Config
-- ---@field notify boolean
-- ---@field delay_timer number
-- ---@field colors table<string, string>
-- local config = {
--   notify = true,
--   delay_timer = 150,
--   colors = {
--     bg = "#16161e",
--     fg = "#ff9e64",
--     red = "#ec5f67",
--     blue = "#5fb3b3",
--     green = "#99c794",
--   },
--   keymaps = {
--     play_macro = "Q",
--     yank_macro = "yq",
--     stop_macro = "cq",
--     toggle_record = "q",
--     cycle_next = "<c-n>",
--     cycle_prev = "<c-p>",
--     toggle_macro_menu = "<m-q>",
--   },
-- }

---@type LazyPluginSpec[]
local M = {
  {
    "ecthelionvi/NeoComposer.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    opts = {},
  },
}

return M
