require("colorizer").setup({
  filetypes = { "*", "!cmp_menu" },
  user_default_options = {
    RRGGBBAA = true, -- #RRGGBBAA hex codes
    AARRGGBB = true, -- #0xAARRGGBA hex codes
    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    -- Available modes: foreground, background
    mode = "virtualtext", -- Set the display mode.
    tailwind = false,
    sass = { enable = true },
  },
  buftypes = { "*", "!terminal", "!prompt", "!popup" },
})
