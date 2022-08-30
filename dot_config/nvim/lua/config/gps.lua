local status_ok, gps = pcall(require, "nvim-gps")
if not status_ok then
	return
end

local i = require("config.icons")

gps.setup({
	disable_icons = false, -- Setting it to true will disable all icons
	icons = {
		["class-name"] = i.Class .. " ", -- Classes and class-like objects
		["function-name"] = i.Function .. " ", -- Functions
		["method-name"] = i.Method .. " ", -- Methods (functions inside class-like objects)
		["container-name"] = i.Object .. " ", -- Containers (example: lua tables)
		["tag-name"] = i.Tag .. " ", -- Tags (example: html tags)
		["mapping-name"] = i.Object .. " ",
		["sequence-name"] = i.Array .. " ",
		["null-name"] = i.Field .. " ",
		["boolean-name"] = i.Boolean .. " ",
		["integer-name"] = i.Number .. " ",
		["float-name"] = i.Number .. " ",
		["string-name"] = i.String .. " ",
		["array-name"] = i.Array .. " ",
		["object-name"] = i.Object .. " ",
		["number-name"] = i.Number .. " ",
		["table-name"] = i.Table .. " ",
		["date-name"] = i.Calendar .. " ",
		["date-time-name"] = i.Table .. " ",
		["inline-table-name"] = i.Calendar .. " ",
		["time-name"] = i.Watch .. " ",
		["module-name"] = i.Module .. " ",
	},

	-- Add custom configuration per language or
	-- Disable the plugin for a language
	-- Any language not disabled here is enabled by default
	languages = {},

	separator = " " .. i.ChevronRight .. " ",

	-- limit for amount of context shown
	-- 0 means no limit
	depth = 0,

	-- indicator used when context hits depth limit
	depth_limit_indicator = "..",
})
