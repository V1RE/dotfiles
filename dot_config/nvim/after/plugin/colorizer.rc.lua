require("colorizer").setup({
  filetypes = { "sass", "css" },
  user_default_options = {
    RRGGBBAA = false, -- #RRGGBBAA hex codes
    AARRGGBB = false, -- #0xAARRGGBA hex codes
    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    -- Available modes: foreground, background
    mode = "background", -- Set the display mode.
    tailwind = false,
    sass = { enable = true },
  },
  buftypes = { "*", "!terminal", "!prompt", "!popup", "!nofile" },
})
