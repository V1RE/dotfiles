---@type LazyPluginSpec[]
return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make BUILD_FROM_SOURCE=true",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
      "zbirenbaum/copilot.lua",
    },
    keys = {
      { "<leader>at", "<cmd>AvanteToggle<cr>", desc = "Toggle Sidebar", mode = { "n", "v" } },
      { "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "Ask AI", mode = { "n", "v" } },
      { "<leader>an", "<cmd>AvanteChatNew<cr>", desc = "New Chat", mode = { "n", "v" } },
      { "<leader>ae", "<cmd>AvanteEdit<cr>", desc = "Edit Code", mode = { "n", "v" } },
      { "<leader>ah", "<cmd>AvanteHistory<cr>", desc = "Chat History", mode = { "n", "v" } },
      { "<leader>aS", "<cmd>AvanteStop<cr>", desc = "Stop Request", mode = { "n", "v" } },
      { "<leader>ap", "<cmd>AvanteSwitchProvider<cr>", desc = "Switch Provider", mode = { "n", "v" } },
    },
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      provider = "copilot",
      file_selector = {
        provider = "snacks",
      },
      -- Highlights integration with catppuccin
      highlights = {
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      -- Mappings
      mappings = {
        submit = {
          normal = "<CR>",
          insert = "<C-CR>",
        },
        ask = "<leader>aa",
        edit = "<leader>ae",
        toggle = {
          default = "<leader>at",
          debug = "<leader>ad",
          hint = "<leader>ah",
        },
      },
      -- Better integration with external tools
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = true,
        minimize_diff = true,
        enable_token_counting = true,
        auto_add_current_file = true,
        auto_approve_tool_permissions = false,
        confirmation_ui_style = "inline_buttons",
      },
      mode = "agentic",
    },
  },

  -- render-markdown.nvim (required dependency)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      file_types = { "markdown", "Avante" },
      anti_conceal = {
        enabled = true,
      },
      code = {
        enabled = true,
        sign = true,
        style = "full",
        position = "left",
        width = "full",
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = "thin",
      },
      heading = {
        enabled = true,
        sign = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
    },
  },

  -- Update which-key for avante mappings
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      local icons = require("config.icons")
      opts.spec = opts.spec or {}
      table.insert(opts.spec, {
        "<leader>a",
        group = "AI Assistant",
        icon = icons.Robot,
        nowait = true,
        remap = false,
      })
    end,
  },
}
