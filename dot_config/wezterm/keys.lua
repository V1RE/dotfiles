return {
	{
		key = "[",
		mods = "CMD",
		action = {
			Multiple = { { SendKey = { key = "b", mods = "CTRL" } }, { SendKey = { key = "h", mods = "CTRL" } } },
		},
	},
	{
		key = "]",
		mods = "CMD",
		action = {
			Multiple = { { SendKey = { key = "b", mods = "CTRL" } }, { SendKey = { key = "l", mods = "CTRL" } } },
		},
	},
	{ key = "t", mods = "CMD", action = "DisableDefaultAssignment" },
	{ key = "w", mods = "CMD", action = "DisableDefaultAssignment" },
}
