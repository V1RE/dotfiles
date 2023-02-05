local M = {}

---@param keys table
---@param mode? "n"|"i"|"v" default: "n"
function M.map(keys, mode)
  require("which-key").register(keys, { nowait = true, mode = mode or "n" })
end

return M
