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
