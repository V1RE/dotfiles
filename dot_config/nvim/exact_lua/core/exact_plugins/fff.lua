local i = require("config.icons")

---@type LazyPluginSpec[]
return {
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      -- this will download prebuild binary or try to use existing rustup toolchain to build from source
      -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
      require("fff.download").download_or_build_binary()
    end,
    -- if you are using nixos
    -- build = "nix run .#release",
    opts = { -- (optional)
      debug = {
        enabled = true, -- we expect your collaboration at least during the beta
        show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
      },
      layout = {
        height = 0.8,
        width = 0.8,
        prompt_position = "top",
        preview_position = "right", -- or 'left', 'right', 'top', 'bottom'
        preview_size = 0.5,
      },

      preview = {
        line_numbers = true,
      },
    },
    -- No need to lazy-load with lazy.nvim.
    -- This plugin initializes itself lazily.
    lazy = false,
    keys = {
      {
        "ff", -- try it if you didn't it is a banger keybinding for a picker
        function()
          require("fff").find_files()
        end,
        desc = "FFFind files",
      },

      {
        "<leader>f",
        function()
          require("fff").find_in_git_root()
        end,
        desc = i.Telescope .. "Find files",
      },
    },
    enabled = false
  },
}
