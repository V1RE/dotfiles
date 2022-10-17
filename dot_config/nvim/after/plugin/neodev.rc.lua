require("neodev").setup({
  override = function(root_dir, library)
    print(root_dir)
    if require("neodev.util").has_file(root_dir, "~/.local/share/chezmoi/dot_config/nvim") then
      library.enabled = true
      library.plugins = true
    end
  end,
})
