local a_ok, a = pcall(require, "alpha")
local db_ok, db = pcall(require, "alpha.themes.dashboard")

if not (a_ok and db_ok) then
	return
end

local i = require("config.icons")

db.section.header.val = {
	[[                               __                ]],
	[[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
	[[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
	[[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
	[[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
	[[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
}

db.section.buttons.val = {
	db.button("f", i.ui.Telescope .. " Find file", ":Telescope find_files <CR>"),
	db.button("e", i.ui.Create .. " New file", ":ene <BAR> startinsert <CR>"),
	db.button("p", i.ui.Project .. " Find project", ":Telescope projects <CR>"),
	db.button("r", i.ui.History .. " Recently used files", ":Telescope oldfiles <CR>"),
	db.button("t", i.ui.SearchCode .. " Find text", ":Telescope live_grep <CR>"),
	db.button("c", i.ui.Gear .. " Configuration", ":e ~/.config/nvim/init.lua <CR>"),
	db.button("q", i.ui.Close .. " Quit Neovim", ":qa<CR>"),
}

local function header()
	local lines = {}
	local handle = io.popen("figlet -f 'big' $(basename $PWD)")
	if handle == nil then
		return db.section.header.val
	end
	for line in handle:lines() do
		table.insert(lines, line)
	end
	handle:close()
	return lines
end

db.section.header.val = header()

db.section.footer.opts.hl = "Type"
db.section.header.opts.hl = "Include"
db.section.buttons.opts.hl = "Keyword"

db.opts.opts.noautocmd = true
a.setup(db.opts)
