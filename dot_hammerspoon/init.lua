--[[ hs.loadSpoon("EmmyLua"):init() ]]
hs.loadSpoon("ControlEscape"):start()

--[[ local switcher = hs.window.switcher.new({ "Arc", "WezTerm" }) ]]

local function centerMouse()
  local screen = hs.screen.primaryScreen()
  local center = screen:fullFrame().center
  hs.mouse.absolutePosition(center)
end

hs.hotkey.bind({ "cmd", "ctrl" }, "l", function()
  centerMouse()
  hs.application.get("company.thebrowser.Browser"):activate(true)
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "h", function()
  centerMouse()
  hs.application.get("com.github.wez.wezterm"):activate(true)
end)
