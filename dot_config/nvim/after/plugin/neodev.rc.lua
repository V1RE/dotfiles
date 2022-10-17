require("neodev").setup({
  override = function(root_dir, library)
    if require("neodev.util").has_file(root_dir, "/Users/niels/.local/share/chezmoi") then
      library.enabled = true
      library.plugins = true
    end
  end,
})
