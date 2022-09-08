hs.loadSpoon("ControlEscape"):start()

--[[ local switcher = hs.window.switcher.new({ "Arc", "WezTerm" }) ]]

hs.hotkey.bind({ "cmd", "ctrl" }, "l", function()
  hs.application.get("Arc"):activate(true)
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "h", function()
  hs.application.open("WezTerm")
end)
