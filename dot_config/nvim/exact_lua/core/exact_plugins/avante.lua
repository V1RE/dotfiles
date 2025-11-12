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

  -- Update blink.cmp to include avante sources
  {
    "saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      local icons = require("config.icons")

      -- Add avante to sources
      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or {}

      -- Insert avante after copilot in the sources list
      local sources = opts.sources.default
      local copilot_idx = nil
      for i, source in ipairs(sources) do
        if source == "copilot" then
          copilot_idx = i
          break
        end
      end

      if copilot_idx then
        table.insert(sources, copilot_idx + 1, "avante")
      else
        table.insert(sources, "avante")
      end

      -- Configure avante provider
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.avante = {
        name = "avante",
        module = "blink.compat.source",
        score_offset = 7, -- Between copilot (8) and codeium (9)
        async = true,
        max_items = 3,
        opts = {
          source_name = "avante_commands",
        },
        transform_items = function(_, items)
          for _, item in ipairs(items) do
            item.kind_icon = icons.Robot
            item.kind_name = "Avante"
          end
          return items
        end,
      }

      return opts
    end,
  },
}
