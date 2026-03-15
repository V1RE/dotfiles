---@type LazyPluginSpec
return {
  "ahmedkhalf/project.nvim",
  main = "project_nvim",
  ---@type ProjectOptions
  opts = {
    silent_chdir = true,
    manual_mode = true,
    detection_methods = { "pattern" },
  },
}
