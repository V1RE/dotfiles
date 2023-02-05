require("colorizer").setup({
  user_default_options = {
    RRGGBBAA = false, -- #RRGGBBAA hex codes
    AARRGGBB = false, -- #0xAARRGGBA hex codes
    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    -- Available modes: foreground, background
    mode = "background", -- Set the display mode.
    names = false,
    tailwind = true,
    sass = { enable = true },
  },
  buftypes = { "*", "!terminal", "!prompt", "!popup", "!nofile" },
})
