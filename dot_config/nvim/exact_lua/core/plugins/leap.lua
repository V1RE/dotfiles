---@type LazyPluginSpec
local M = {
  "ggandor/leap.nvim",
  enabled = false,
  event = "VeryLazy",
  dependencies = { { "ggandor/flit.nvim", opts = { labeled_modes = "nv" } } },
  config = function(_, opts)
    local leap = require("leap")
    for k, v in pairs(opts) do
      leap.opts[k] = v
    end
    leap.add_default_mappings(true)
  end,
  opts = {
    highlight_unlabeled_phase_one_targets = true,
  },
}

return M
