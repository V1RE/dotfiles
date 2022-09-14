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
  local arc = hs.application.get("company.thebrowser.Browser")
  if arc:isFrontmost() then
    arc:hide()
  else
    arc:activate(true)
  end
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "h", function()
  centerMouse()
  local wezterm = hs.application.get("com.github.wez.wezterm")
  if wezterm:isFrontmost() then
    wezterm:hide()
  else
    wezterm:activate(true)
  end
end)
