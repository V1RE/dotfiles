---@type LazyPluginSpec[]
local M = {
  {
    "rmagatti/goto-preview",
    setup = true,
    keys = {
      {
        "gpd",
        function()
          require("goto-preview").goto_preview_definition()
        end,
      },
      {
        "gpt",
        function()
          require("goto-preview").goto_preview_type_definition()
        end,
      },
      {
        "gpi",
        function()
          require("goto-preview").goto_preview_implementation()
        end,
      },
      {
        "gP",
        function()
          require("goto-preview").close_all_win()
        end,
      },
      {
        "gpr",
        function()
          require("goto-preview").goto_preview_references()
        end,
      },
    },
  },
}

return M
