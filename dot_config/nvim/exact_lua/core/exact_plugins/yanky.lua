---@type LazyPluginSpec
return {
  "gbprod/yanky.nvim",

  keys = {
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after" },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before" },
    { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put after" },
    { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put before" },
    { "<c-n>", "<Plug>(YankyNextEntry)", desc = "Next yank history entry" },
    { "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Previous yank history entry" },
  },
}
