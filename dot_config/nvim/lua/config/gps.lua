local status_ok, gps = pcall(require, "nvim-gps")
if not status_ok then
	return
end

local i = require("config.icons")

gps.setup({
	disable_icons = false, -- Setting it to true will disable all icons
	icons = {
		["class-name"] = i.kind.Class .. " ", -- Classes and class-like objects
		["function-name"] = i.kind.Function .. " ", -- Functions
		["method-name"] = i.kind.Method .. " ", -- Methods (functions inside class-like objects)
		["container-name"] = i.type.Object .. " ", -- Containers (example: lua tables)
		["tag-name"] = i.misc.Tag .. " ", -- Tags (example: html tags)
		["mapping-name"] = i.type.Object .. " ",
		["sequence-name"] = i.type.Array .. " ",
		["null-name"] = i.kind.Field .. " ",
		["boolean-name"] = i.type.Boolean .. " ",
		["integer-name"] = i.type.Number .. " ",
		["float-name"] = i.type.Number .. " ",
		["string-name"] = i.type.String .. " ",
		["array-name"] = i.type.Array .. " ",
		["object-name"] = i.type.Object .. " ",
		["number-name"] = i.type.Number .. " ",
		["table-name"] = i.ui.Table .. " ",
		["date-name"] = i.ui.Calendar .. " ",
		["date-time-name"] = i.ui.Table .. " ",
		["inline-table-name"] = i.ui.Calendar .. " ",
		["time-name"] = i.misc.Watch .. " ",
		["module-name"] = i.kind.Module .. " ",
	},

	-- Add custom configuration per language or
	-- Disable the plugin for a language
	-- Any language not disabled here is enabled by default
	languages = {},

	separator = " " .. i.ui.ChevronRight .. " ",

	-- limit for amount of context shown
	-- 0 means no limit
	depth = 0,

	-- indicator used when context hits depth limit
	depth_limit_indicator = "..",
})
