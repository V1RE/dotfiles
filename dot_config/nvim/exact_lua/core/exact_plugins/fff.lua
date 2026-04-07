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
    opts = {
      debug = {
        enabled = false,
        show_scores = false,
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
      keymaps = {
        focus_list = nil,
        focus_preview = nil,
      },
    },
    -- No need to lazy-load with lazy.nvim.
    -- This plugin initializes itself lazily.
    lazy = false,
    keys = {
      {
        "ff",
        function()
          require("fff").find_files()
        end,
        desc = "FFFind files",
      },
      {
        "<leader>f",
        function()
          require("fff").find_files()
        end,
        desc = i.Telescope .. "Find files",
      },
      {
        "<leader>F",
        function()
          require("fff").live_grep()
        end,
        desc = i.Search .. "Find text",
      },
      {
        "<leader>k",
        function()
          local current_file = vim.api.nvim_buf_get_name(0)
          local directory = current_file ~= "" and vim.fs.dirname(current_file) or vim.uv.cwd()
          require("fff").find_files_in_dir(directory)
        end,
        desc = i.Telescope .. "Find files cwd",
      },
    },
    enabled = false,
  },
}
