local i = require("config.icons")

---@type LazyPluginSpec
return {
  "stevearc/oil.nvim",
  ---@type oil.SetupOpts
  opts = {
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    keymaps = {
      ["gy"] = {
        function()
          local dir = require("oil").get_current_dir()
          vim.fn.setreg("+", dir)
          vim.notify("Copied: " .. dir)
        end,
        desc = "Copy directory path",
      },
      ["go"] = {
        function()
          local dir = require("oil").get_current_dir()
          vim.fn.system({ "open", dir })
        end,
        desc = "Open in Finder",
      },
      ["<C-l>"] = false,
      ["<C-h>"] = false,
      ["<C-r>"] = "actions.refresh",
    },
  },
  lazy = false,
  keys = {
    { "<leader>e", "<cmd>Oil<cr>", desc = i.NeoTree .. "Show Oil" },
  },
}
