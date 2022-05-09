local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
local i = require("config.icons")

dashboard.section.header.val = {
  [[                               __                ]],
  [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
  [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
  [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
  [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
  [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
}

dashboard.section.buttons.val = {
  dashboard.button("f", i.ui.Telescope .. " Find file", ":Telescope find_files <CR>"),
  dashboard.button("e", i.ui.Create .. " New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("p", i.ui.Project .. " Find project", ":Telescope projects <CR>"),
  dashboard.button("r", i.ui.History .. " Recently used files", ":Telescope oldfiles <CR>"),
  dashboard.button("t", i.ui.SearchCode .. " Find text", ":Telescope live_grep <CR>"),
  dashboard.button("c", i.ui.Gear .. " Configuration", ":e ~/.config/nvim/init.lua <CR>"),
  dashboard.button("q", i.ui.Close .. " Quit Neovim", ":qa<CR>"),
}

local function header()
  local lines = {}
  local handle = io.popen("figlet -f 'big' $(basename $PWD)")
  if handle == nil then
    return dashboard.section.header.val
  end
  for line in handle:lines() do
    table.insert(lines, line)
  end
  handle:close()
  return lines
end

dashboard.section.header.val = header()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
