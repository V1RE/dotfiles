local i = require("config.icons")

---@type LazyPluginSpec
return {
  "mbbill/undotree",
  keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = i.History .. "Undotree" } },
  enabled = false,
}
