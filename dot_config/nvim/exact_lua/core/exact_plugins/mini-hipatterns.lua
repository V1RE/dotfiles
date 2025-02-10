---@type LazyPluginSpec[]
return {
  {
    "echasnovski/mini.hipatterns",
    config = function(_, opts)
      local hipatterns = require("mini.hipatterns")

      hipatterns.setup({
        highlighters = {

          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
    end,
    enabled = false,
  },
}
