hs.loadSpoon("ControlEscape"):start()

local function centerMouse()
  local screen = hs.screen.primaryScreen()
  local center = screen:fullFrame().center
  hs.mouse.absolutePosition(center)
end

hs.hotkey.bind({ "cmd", "ctrl" }, "j", function()
  centerMouse()
  hs.eventtap.keyStroke("cmd", "tab")
  hs.eventtap.keyStroke({})
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
