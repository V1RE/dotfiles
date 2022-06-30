local status_ok, navic = pcall(require, "nvim-navic")
if not status_ok then
	return
end

local i = require("config.icons")

navic.setup({
	icons = {
		File = i.File .. " ",
		Module = i.Module .. " ",
		Namespace = i.Namespace .. " ",
		Package = i.Package .. " ",
		Class = i.Class .. " ",
		Method = i.Method .. " ",
		Property = i.Property .. " ",
		Field = i.Field .. " ",
		Constructor = i.Constructor .. " ",
		Enum = i.Enum .. " ",
		Interface = i.Interface .. " ",
		Function = i.Function .. " ",
		Variable = i.Variable .. " ",
		Constant = i.Constant .. " ",
		String = i.String .. " ",
		Number = i.Number .. " ",
		Boolean = i.Boolean .. " ",
		Array = i.Array .. " ",
		Object = i.Object .. " ",
		Key = i.Key .. " ",
		Null = i.Null .. " ",
		EnumMember = i.EnumMember .. " ",
		Struct = i.Struct .. " ",
		Event = i.Event .. " ",
		Operator = i.Operator .. " ",
		TypeParameter = i.TypeParameter .. " ",
	},

	highlight = true,
	separator = " " .. i.ChevronRight,
})
