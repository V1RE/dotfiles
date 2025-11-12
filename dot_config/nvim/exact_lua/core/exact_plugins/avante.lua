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
    opts = function()
      return {
        -- Use Claude as primary provider
        provider = "claude",
        -- Use Copilot as secondary provider
        copilot = {
          enabled = true,
        },
        -- ACP (Agent Client Protocol) setup for CLI tools
        acp = {
          enabled = true,
          providers = {
            {
              name = "claude_code",
              command = "claude-code",
              description = "Claude Code CLI",
            },
            {
              name = "codex",
              command = "codex",
              description = "OpenAI Codex CLI",
            },
          },
        },
        -- Agentic mode (auto-execute tools)
        mode = "agentic",
        behaviour = {
          -- Disable auto-suggestions (manual trigger only)
          auto_suggestions = false,
          auto_apply_diff = false,
          enable_token_counting = true,
        },
        -- UI configuration
        windows = {
          position = "right",
          width = 30,
          sidebar_header = {
            enabled = true,
            rounded = true,
          },
        },
        -- Use Snacks for file selection
        file_selector = {
          provider = "snacks",
        },
        -- Hints configuration
        hints = {
          enabled = true,
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
      }
    end,
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

  -- Integrate with edgy.nvim for sidebar management
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        title = "Avante",
        ft = "Avante",
        size = { width = 0.3 },
        pinned = false,
      })
      table.insert(opts.right, {
        title = "AvanteInput",
        ft = "AvanteInput",
        size = { width = 0.3 },
        pinned = false,
      })
    end,
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
