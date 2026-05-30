local i = require("config.icons")

---@type LazyPluginSpec[]
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function(_, opts)
      local db = require("snacks.picker.util.db")

      if not db._busy_timeout_patched then
        db._busy_timeout_patched = true

        local new = db.new

        function db.new(path, value_type)
          local store = new(path, value_type)

          if path:find("picker%-frecency%.sqlite3$") then
            -- Multiple Neovim instances can race on frecency writes.
            store:exec("PRAGMA busy_timeout=1000")

            local set = store.set

            function store:set(key, value)
              local ok, err = pcall(set, self, key, value)
              if ok then
                return
              end
              if tostring(err):find("Failed to execute insert statement", 1, true) then
                return
              end
              error(err)
            end
          end

          return store
        end
      end

      require("snacks").setup(opts)
    end,
    ---@type snacks.Config
    opts = {
      dashboard = { enabled = true },
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
      dim = { enabled = true },
      image = { enabled = true },
      picker = {
        ui_select = true,
        win = {
          input = {
            keys = {
              ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
            },
          },
        },
        matcher = {
          frecency = true,
        },
      },
    },
    keys = {
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
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
          Snacks.picker.undo()
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
        "<leader>nl",
        function()
          Snacks.picker.notifications()
        end,
        desc = "Notification List",
      },
      {
        "<leader>nh",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification History",
      },
      {
        "<leader>na",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss Notifications",
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
        "<leader>k",
        function()
          local current_file = vim.api.nvim_buf_get_name(0)
          local cwd = current_file ~= "" and vim.fs.dirname(current_file) or vim.uv.cwd()
          Snacks.picker.files({ cwd = cwd })
        end,
        desc = i.Telescope .. "Find files cwd",
      },
      {
        "<leader>sC",
        function()
          Snacks.picker.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>sm",
        function()
          Snacks.picker.man()
        end,
        desc = "Man Pages",
      },
      {
        "<leader>sR",
        function()
          Snacks.picker.registers()
        end,
        desc = "Registers",
      },
      {
        "<leader>sb",
        function()
          Snacks.picker.pickers()
        end,
        desc = "Builtin pickers",
      },
      {
        "<leader>sc",
        function()
          Snacks.picker.colorschemes()
        end,
        desc = "Colorscheme",
      },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>sr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Open Recent File",
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
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "Workspace Symbols",
      },
      {
        "<leader>ls",
        function()
          Snacks.picker.lsp_symbols()
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
      {
        "<leader>xx",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>xw",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Workspace Diagnostics",
      },
      {
        "<leader>xd",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Buffer Diagnostics",
      },
      {
        "<leader>xl",
        function()
          Snacks.picker.loclist()
        end,
        desc = "Location List",
      },
      {
        "<leader>xq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix List",
      },
      {
        "gR",
        function()
          Snacks.picker.lsp_references()
        end,
        desc = "References",
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          ---@diagnostic disable-next-line: duplicate-set-field
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          ---@diagnostic disable-next-line: duplicate-set-field
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command
        end,
      })
    end,
  },
}
