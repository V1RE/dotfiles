require("illuminate").configure({
  -- providers: provider used to get references in the buffer, ordered by priority
  providers = {
    "lsp",
    "treesitter",
  },
  delay = 100,
  filetypes_denylist = {
    "dirvish",
    "fugitive",
    "NvimTree",
  },
  under_cursor = false,
})
