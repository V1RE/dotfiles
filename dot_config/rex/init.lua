-- Rex keybindings, mirroring the Ghostty + Herdr setup.
-- Docs: https://www.superlogical.com/rex/docs/customize/config
-- Apply with `rex config reload`; validate with `rex config check`.
--
-- Rex terms: session = Herdr workspace, tab = Herdr tab, pane = Herdr pane.
-- Appearance (theme, font, opacity, option-as-alt) lives in the Rex app settings,
-- not in this file.

local terminal = "com.superlogical.terminal"

-- Prefix: cmd+b, then hjkl splits in that direction (WezTerm parity).
rex.bind("cmd+b>h", "pane.split", { direction = "left" })
rex.bind("cmd+b>j", "pane.split", { direction = "down" })
rex.bind("cmd+b>k", "pane.split", { direction = "up" })
rex.bind("cmd+b>l", "pane.split", { direction = "right" })
rex.bind("cmd+b>x", "pane.close")
rex.bind("cmd+b>z", "pane.zoom")
rex.bind("cmd+b>r", "client.mode.enter", { name = "resize" })
rex.bind("cmd+b>shift+t", "client.tab.rename")
rex.bind("cmd+b>shift+w", "session.rename")
rex.bind("cmd+b>shift+d", "session.close")
rex.bind("cmd+b>shift+n", "session.new")
rex.bind("cmd+b>shift+r", "client.config.reload")
for i = 1, 9 do
  rex.bind("cmd+b>" .. i, "client.tab.goto", { index = i })
end

-- Resize mode: hjkl resizes until escape.
for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("resize/" .. key, "pane.resize", { direction = direction })
end
rex.bind("resize/escape", "client.mode.exit")
rex.bind("resize/enter", "client.mode.exit")

-- Tabs.
rex.bind("cmd+t", "client.tab.new")
rex.bind("cmd+w", "client.tab.close")
rex.bind("cmd+h", "client.tab.previous")
rex.bind("cmd+l", "client.tab.next")

-- Sessions (Herdr workspaces).
rex.bind("cmd+j", "session.next")
rex.bind("cmd+k", "session.previous")
rex.bind("cmd+m", "session.switch")
rex.bind("cmd+n", "session.new")

-- cmd+k is taken above, so keep the palette reachable.
rex.bind("cmd+shift+p", "client.palette.toggle")

-- ctrl+hjkl: move between panes, unless Vim/Neovim runs in the focused pane,
-- in which case the key goes to Vim (same as vim-herdr-navigation).
local vim_names = { vi = true, vim = true, nvim = true, view = true, gvim = true, vimdiff = true, nvimdiff = true }

local function runs_vim()
  local info = rex.block.call(terminal, "process", {})
  local fg = info and info.foreground
  if not fg then
    return false
  end
  local name = (fg.name or ""):lower()
  return vim_names[name] == true
end

for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("ctrl+" .. key, function()
    if runs_vim() then
      return false
    end
    rex.session.focus_direction({ direction = direction })
    return true
  end)
end

-- shift+enter sends ESC CR, like the Ghostty/WezTerm setup.
rex.bind("shift+enter", function()
  rex.block.call(terminal, "write", { data = "\27\r" })
  return true
end)
