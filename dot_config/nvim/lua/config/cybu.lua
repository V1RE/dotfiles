local cybu_ok, cybu = pcall(require, "cybu")
if not cybu_ok then
  return
end

cybu.setup({
  position = {
    relative_to = "editor",
    anchor = "center",
    max_win_height = 7,
  },
  style = {
    border = "rounded",
    path = "tail",
    padding = 2,
    hide_buffer_id = true,
  },
  exclude = {
    "neo-tree",
    "fugitive",
    "qf",
    "NvimTree",
    "alpha",
  },
})
