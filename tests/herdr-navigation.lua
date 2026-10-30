-- nvim --headless -u NONE -l tests/herdr-navigation.lua
local navigation = dofile("dot_config/nvim/exact_lua/herdr_navigation.lua")
local original_system = vim.fn.system
local original_terminal = vim.env.HC_TERMINAL_ID
vim.env.HC_TERMINAL_ID = "t-test"
local calls = {}
local current_pane = "p-test"
vim.fn.system = function(args)
  table.insert(calls, args)
  if args[2] == "ls" then
    return vim.json.encode({ spaces = { { tabs = { { terminals = { { terminal = "t-test", pane = "p-test" } } } } } } })
  elseif args[2] == "status" then
    return vim.json.encode({ focused_pane = current_pane })
  end
  return "{}"
end

vim.cmd("vsplit")
local left = vim.api.nvim_get_current_win()
vim.cmd("wincmd l")
navigation.navigate("left")
assert(vim.api.nvim_get_current_win() == left, "must move within Neovim first")
assert(#calls == 0, "internal splits must not call Herdr")

navigation.navigate("left")
assert(#calls == 3, "edge must inspect source and focus, then navigate")
assert(calls[3][3] == "pane.go" and calls[3][5] == "left", "must navigate the requested direction")

calls = {}
current_pane = "p-other"
navigation.navigate("left")
assert(#calls == 2, "changed focus must not move another pane")

calls = {}
navigation.navigate("invalid")
assert(#calls == 0, "invalid directions must do nothing")

vim.fn.system = original_system
vim.env.HC_TERMINAL_ID = original_terminal
print("Neovim internal split, boundary, changed-focus and invalid-input tests passed")
vim.cmd("qa!")
