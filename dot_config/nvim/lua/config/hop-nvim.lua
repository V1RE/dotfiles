local status_ok = pcall(require, "hop")
if not status_ok then
  return
end

require("hop").setup({})
