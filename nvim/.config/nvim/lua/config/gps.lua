local status_gps_ok, gps = pcall(require, "nvim-gps")
if not status_gps_ok then
  return
end

local icons = require("config.icons")

gps.setup({
  disable_icons = false, -- Setting it to true will disable all icons
  icons = {
    ["class-name"] = icons.kind.Class .. " ", -- Classes and class-like objects
    ["function-name"] = icons.kind.Function .. " ", -- Functions
    ["method-name"] = icons.kind.Method .. " ", -- Methods (functions inside class-like objects)
    ["container-name"] = icons.type.Object .. " ", -- Containers (example: lua tables)
    ["tag-name"] = icons.misc.Tag .. " ", -- Tags (example: html tags)
    ["mapping-name"] = icons.type.Object .. " ",
    ["sequence-name"] = icons.type.Array .. " ",
    ["null-name"] = icons.kind.Field .. " ",
    ["boolean-name"] = icons.type.Boolean .. " ",
    ["integer-name"] = icons.type.Number .. " ",
    ["float-name"] = icons.type.Number .. " ",
    ["string-name"] = icons.type.String .. " ",
    ["array-name"] = icons.type.Array .. " ",
    ["object-name"] = icons.type.Object .. " ",
    ["number-name"] = icons.type.Number .. " ",
    ["table-name"] = icons.ui.Table .. " ",
    ["date-name"] = icons.ui.Calendar .. " ",
    ["date-time-name"] = icons.ui.Table .. " ",
    ["inline-table-name"] = icons.ui.Calendar .. " ",
    ["time-name"] = icons.misc.Watch .. " ",
    ["module-name"] = icons.kind.Module .. " ",
  },

  -- Add custom configuration per language or
  -- Disable the plugin for a language
  -- Any language not disabled here is enabled by default
  languages = {},

  separator = " " .. icons.ui.ChevronRight .. " ",

  -- limit for amount of context shown
  -- 0 means no limit
  depth = 0,

  -- indicator used when context hits depth limit
  depth_limit_indicator = "..",
})
