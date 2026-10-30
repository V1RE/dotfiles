local M = {}

function M.navigate(direction)
  local commands = { left = "h", down = "j", up = "k", right = "l" }
  local command = commands[direction]
  if not command then
    return
  end

  local previous = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. command)
  if vim.api.nvim_get_current_win() ~= previous then
    return
  end

  -- Only the currently focused local Herdr terminal may move the window's focus.
  local output = vim.fn.system({ "herdr-app", "ls" })
  if vim.v.shell_error ~= 0 then
    vim.notify("Herdr navigation: local herdr-app unavailable", vim.log.levels.WARN)
    return
  end
  local ok, listing = pcall(vim.json.decode, output)
  if not ok or type(listing) ~= "table" or type(listing.spaces) ~= "table" then
    return
  end
  local source_pane
  for _, space in ipairs(listing.spaces) do
    for _, tab in ipairs(space.tabs or {}) do
      for _, terminal in ipairs(tab.terminals or {}) do
        if terminal.terminal == vim.env.HC_TERMINAL_ID then
          source_pane = terminal.pane
        end
      end
    end
  end
  if not source_pane then
    return
  end
  -- Check current focus last, so a key never navigates a different terminal.
  local status_output = vim.fn.system({ "herdr-app", "status" })
  if vim.v.shell_error ~= 0 then
    return
  end
  local decoded, status = pcall(vim.json.decode, status_output)
  if decoded and type(status) == "table" and status.focused_pane == source_pane then
    vim.fn.system({ "herdr-app", "do", "pane.go", "--direction", direction })
    if vim.v.shell_error ~= 0 then
      vim.notify("Herdr navigation failed", vim.log.levels.WARN)
    end
  end
end

return M
