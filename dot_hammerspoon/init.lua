hs.loadSpoon("ControlEscape"):start()

local function centerMouse()
  local screen = hs.screen.primaryScreen()
  local center = screen:fullFrame().center
  hs.mouse.absolutePosition(center)
end

local logger = hs.logger.new("init.lua", "debug")

local function devTools()
  local app = hs.application.find("com.google.Chrome.canary")
  local window = app:findWindow("- react native devtools")

  logger:d(app, window)

  if app:isFrontmost() then
    app:hide()
  else
    window:focus()
  end
end

hs.hotkey.bind({ "cmd", "ctrl" }, "j", function()
  centerMouse()
  hs.eventtap.keyStroke("cmd", "tab")
  hs.eventtap.keyStroke({})
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "n", function()
  devTools()
end)
