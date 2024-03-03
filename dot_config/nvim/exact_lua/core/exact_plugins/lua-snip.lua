---@type LazyPluginSpec
local M = {
  "L3MON4D3/LuaSnip",

  build = vim.fn.has("win32") ~= 0 and "make install_jsregexp" or nil,

  dependencies = {
    "rafamadriz/friendly-snippets",
  },

  config = function(_, opts)
    local ls = require("luasnip")

    ls.config.setup(opts)

    vim.tbl_map(function(type)
      require("luasnip.loaders.from_" .. type).lazy_load()
    end, { "vscode", "snipmate", "lua" })

    -- friendly-snippets - enable standardized comments snippets
    ls.filetype_extend("typescript", { "tsdoc" })
    ls.filetype_extend("javascript", { "jsdoc" })
    ls.filetype_extend("lua", { "luadoc" })
    ls.filetype_extend("rust", { "rustdoc" })
    ls.filetype_extend("sh", { "shelldoc" })

    require("config.snippets")
  end,
}

return M
