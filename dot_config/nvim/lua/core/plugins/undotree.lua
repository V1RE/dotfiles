local i = require("config.icons")

---@type LazyPluginSpec
local M = {
  "mbbill/undotree",
  keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = i.History .. "Undotree" } },
}

return M
