-- Rex keybindings, mirroring the Ghostty + Herdr setup.
-- Docs: https://www.superlogical.com/rex/docs/customize/config
-- Apply with `rex config reload`; validate with `rex config check`.
--
-- Rex terms: session = Herdr workspace, tab = Herdr tab, pane = Herdr pane.
-- Appearance (theme, font, opacity, option-as-alt) lives in the Rex app settings,
-- not in this file.

local terminal = "com.superlogical.terminal"

-- Process tree of the focused pane --------------------------------------------
-- Rex only sees the pane's direct child (/usr/bin/login, which runs as root), and
-- the shell runs one level deeper under `atuin pty-proxy` on its own tty. So walk
-- the descendants with ps instead of trusting the terminal's `process` result.

local function basename(path)
  return (path:match("([^/]+)$") or path):gsub("^%-", ""):lower()
end

-- Returns the descendants of the focused pane's child process, outermost first,
-- each as { pid, comm, foreground }.
local function pane_processes()
  local info = rex.block.call(terminal, "process", {})
  local root = info and info.child and info.child.pid
  if not root then
    return {}
  end
  local ps = rex.exec({ "ps", "-A", "-o", "pid=,ppid=,pgid=,tpgid=,comm=" })
  if not ps or not ps.ok then
    return {}
  end
  local children = {}
  for line in ps.stdout:gmatch("[^\n]+") do
    local pid, ppid, pgid, tpgid, comm = line:match("^%s*(%d+)%s+(%d+)%s+(%d+)%s+(%-?%d+)%s+(.+)$")
    if pid then
      children[ppid] = children[ppid] or {}
      table.insert(children[ppid], {
        pid = pid,
        comm = basename(comm),
        foreground = pgid == tpgid,
      })
    end
  end
  local out, queue = {}, { tostring(root) }
  while #queue > 0 do
    local pid = table.remove(queue, 1)
    for _, child in ipairs(children[pid] or {}) do
      table.insert(out, child)
      table.insert(queue, child.pid)
    end
  end
  return out
end

local shells = { zsh = true, bash = true, fish = true, sh = true, nu = true }
local vims = { vi = true, vim = true, nvim = true, view = true, gvim = true, vimdiff = true, nvimdiff = true }

-- Directory of the innermost shell in the focused pane.
local function focused_cwd()
  local shell
  for _, p in ipairs(pane_processes()) do
    if shells[p.comm] then
      shell = p.pid
    end
  end
  if not shell then
    return nil
  end
  local r = rex.exec({ "lsof", "-a", "-p", shell, "-d", "cwd", "-Fn" })
  return r and r.ok and r.stdout:match("\nn([^\n]+)") or nil
end

local function runs_vim()
  for _, p in ipairs(pane_processes()) do
    if p.foreground and vims[p.comm] then
      return true
    end
  end
  return false
end

-- Prefix ----------------------------------------------------------------------
-- cmd+b, then hjkl splits in that direction (WezTerm parity).
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

-- Tabs ------------------------------------------------------------------------
-- New tabs open in the focused pane's directory (Herdr new_cwd = "follow").
rex.action({
  name = "tab_new_here",
  title = "New Tab in Current Directory",
  category = "Tabs",
  run = function()
    rex.session.new_window({
      layout = rex.layout.block({
        flavor = "com.superlogical.terminal.shell",
        options = { cwd = focused_cwd() },
      }),
    })
  end,
})

rex.bind("cmd+t", "tab_new_here")
rex.bind("cmd+w", "client.tab.close")
rex.bind("cmd+h", "client.tab.previous")
rex.bind("cmd+l", "client.tab.next")

-- Sessions (Herdr workspaces) -------------------------------------------------
rex.bind("cmd+j", "session.next")
rex.bind("cmd+k", "session.previous")
rex.bind("cmd+m", "session.switch")
rex.bind("cmd+n", "session.new")

-- cmd+k is taken above, so keep the palette reachable.
rex.bind("cmd+shift+p", "client.palette.toggle")

-- Pane navigation -------------------------------------------------------------
-- ctrl+hjkl moves between panes, unless Vim/Neovim runs in the focused pane, in
-- which case the key goes to Vim (same as vim-herdr-navigation).
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
