local i = require("config.icons")

---@type LazyPluginSpec[]
local M = {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" }, -- priority of signs on the left (high to low)
        right = { "fold", "git" }, -- priority of signs on the right (high to low)
      },
      words = { enabled = true },
      lazygit = {},
      picker = {
        ui_select = true,
      },
    },
    keys = {
      {
        "<leader>gg",
        function()
          Snacks.lazygit.open()
        end,
        desc = "Lazygit (cwd)",
      },
      {
        "gn",
        function()
          Snacks.words.jump(1, true)
        end,
        desc = "Go to next word",
      },
      {
        "gp",
        function()
          Snacks.words.jump(-1, true)
        end,
        desc = "Go to previous word",
      },
      {
        "<leader>u",
        function()
          Snacks.picker(Snacks.picker.sources.undo)
        end,
        desc = "Undo history",
      },

      {
        "<leader><leader>",
        function()
          Snacks.picker.resume()
        end,
        desc = i.Watch .. "Resume Picker",
      },

      {
        "<leader>f",
        function()
          Snacks.picker.files({ hidden = true })
        end,
        desc = i.Telescope .. "Find files",
      },
      {
        "<leader>F",
        function()
          Snacks.picker.grep()
        end,
        desc = i.Search .. "Find text",
      },
      {
        "<leader>sh",
        function()
          Snacks.picker.help()
        end,
        desc = "Find Help",
      },

      {
        "gd",
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = i.Constant .. "Definition",
      },
      {
        "gi",
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = i.Interface .. "Implementations",
      },
      {
        "gr",
        function()
          Snacks.picker.lsp_references()
        end,
        nowait = true,
        desc = i.Reference .. "References",
      },
      {
        "<leader>lS",
        function()
          Snacks.picker.lsp_symbols({ workspace = true })
        end,
        desc = "Workspace Symbols",
      },
      {
        "<leader>ls",
        function()
          Snacks.picker.lsp_symbols({ workspace = false })
        end,
        desc = "Document Symbols",
      },
      {
        "<leader>lw",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Workspace Diagnostics",
      },
    },
    init = function()
      vim.api.nvim_create_user_command("Snacks", function(command)
        Snacks.picker.pick(command.args or "files")
      end, {
        bar = true,
        bang = true,
      })
    end,

    cmd = { "Snacks" },
  },
}

return M
