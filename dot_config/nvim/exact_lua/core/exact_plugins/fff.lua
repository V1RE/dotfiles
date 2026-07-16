local i = require("config.icons")

---@type LazyPluginSpec[]
return {
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    lazy = false,
    opts = {},
    keys = {
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
          local cwd = current_file ~= "" and vim.fs.dirname(current_file) or vim.uv.cwd()
          require("fff").find_files_in_dir(cwd)
        end,
        desc = i.Telescope .. "Find files cwd",
      },
    },
  },
}
