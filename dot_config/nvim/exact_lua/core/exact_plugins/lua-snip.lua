---@type LazyPluginSpec
return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  opts = {
    keep_roots = true,
    link_roots = true,
    link_children = true,
    exit_roots = false,
    delete_check_events = "TextChanged",
  },
  dependencies = {
    "rafamadriz/friendly-snippets",
  },

  config = function(_, opts)
    local ls = require("luasnip")

    ls.config.setup(opts)

    for _, type in ipairs({ "vscode", "snipmate", "lua" }) do
      require("luasnip.loaders.from_" .. type).lazy_load()
    end

    -- friendly-snippets - enable standardized comments snippets
    ls.filetype_extend("typescript", { "tsdoc" })
    ls.filetype_extend("javascript", { "jsdoc" })
    ls.filetype_extend("lua", { "luadoc" })
    ls.filetype_extend("rust", { "rustdoc" })
    ls.filetype_extend("sh", { "shelldoc" })

    require("config.snippets")
  end,
}
