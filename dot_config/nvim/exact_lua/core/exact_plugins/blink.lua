---@type LazyPluginSpec[]
return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = {
      -- Snippet engine
      "L3MON4D3/LuaSnip",
      -- Friendly snippets
      "rafamadriz/friendly-snippets",
      -- Compatibility layer for nvim-cmp sources
      "saghen/blink.compat",
      -- AI completions
      "Exafunction/codeium.nvim",
      "supermaven-inc/supermaven-nvim",
      "zbirenbaum/copilot.lua",
    },
    opts = function()
      local icons = require("config.icons")

      ---@type blink.cmp.Config
      return {
        -- Use nvim-cmp mappings for familiarity
        keymap = {
          preset = "default",
          ["<C-n>"] = { "select_next", "fallback" },
          ["<C-p>"] = { "select_prev", "fallback" },
          ["<C-u>"] = { "scroll_documentation_up", "fallback" },
          ["<C-d>"] = { "scroll_documentation_down", "fallback" },
          ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
          ["<CR>"] = { "accept", "fallback" },
          ["<C-y>"] = { "select_and_accept", "fallback" },
        },

        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = "mono",
        },

        completion = {
          -- Use similar behavior to nvim-cmp
          list = {
            selection = {
              preselect = false,
              auto_insert = true,
            },
          },
          menu = {
            auto_show = true,
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            draw = {
              columns = {
                { "kind_icon" },
                { "label", "label_description", gap = 1 },
                { "kind" },
              },
            },
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            window = {
              border = "rounded",
              winhighlight = "Normal:Normal,FloatBorder:FloatBorder,EndOfBuffer:Normal",
            },
          },
          ghost_text = {
            enabled = true, -- Disable for nvim-cmp like behavior
            show_with_selection = true,
          },
        },

        -- Use luasnip for snippets
        snippets = {
          preset = "luasnip",
        },

        sources = {
          default = { "lspfirst", "lsp", "codeium", "supermaven", "copilot", "path", "snippets", "buffer" },
          providers = {
            -- LSP source (highest priority)
            lspfirst = {
              name = "LSP",
              module = "blink.cmp.sources.lsp",
              fallbacks = { "buffer" },
              score_offset = 100,
              max_items = 3,
            },
            lsp = {
              name = "LSP",
              module = "blink.cmp.sources.lsp",
              fallbacks = { "buffer" },
              score_offset = 5,
              transform_items = function(_, items)
                table.remove(items, 3)
                table.remove(items, 2)
                table.remove(items, 1)

                return items
              end,
            },
            -- Buffer source
            buffer = {
              name = "Buffer",
              module = "blink.cmp.sources.buffer",
              score_offset = -3,
            },
            -- Path source
            path = {
              name = "Path",
              module = "blink.cmp.sources.path",
              score_offset = 3,
              fallbacks = { "buffer" },
            },
            -- Snippets source
            snippets = {
              name = "Snippets",
              module = "blink.cmp.sources.snippets",
              score_offset = -1,
              max_items = 3,
              opts = {
                search_paths = { vim.fn.stdpath("config") .. "/snippets" },
              },
            },

            -- AI sources (limited to 3 total)
            codeium = {
              name = "Codeium",
              module = "codeium.blink",
              async = true,
              score_offset = 9,
              max_items = 1,
              transform_items = function(_, items)
                for _, item in ipairs(items) do
                  item.kind_icon = icons.Robot
                  item.kind_name = "Codeium"
                end
                return items
              end,
            },

            supermaven = {
              name = "supermaven",
              module = "blink.compat.source",
              async = true,
              score_offset = 10,
              max_items = 1,
              opts = {
                source_name = "supermaven",
              },
              transform_items = function(_, items)
                for _, item in ipairs(items) do
                  item.kind_icon = icons.Rocket
                  item.kind_name = "Supermaven"
                end
                return items
              end,
            },
            copilot = {
              name = "copilot",
              module = "blink.compat.source",
              score_offset = 8,
              async = true,
              max_items = 1,
              opts = {
                source_name = "copilot",
              },
              transform_items = function(_, items)
                for _, item in ipairs(items) do
                  item.kind_icon = icons.Copilot
                  item.kind_name = "Copilot"
                end
                return items
              end,
            },
          },
        },

        fuzzy = {
          implementation = "prefer_rust_with_warning",
        },
      }
    end,

    opts_extend = { "sources.default" },
  },

  -- blink.compat for nvim-cmp source compatibility
  {
    "saghen/blink.compat",
    version = "2.*",
    lazy = true,
    opts = {},
  },

  -- Codeium setup
  {
    "Exafunction/codeium.nvim",
    cmd = "Codeium",
    build = ":Codeium Auth",
    opts = {
      enable_cmp_source = true,
    },
  },

  -- Supermaven setup
  {
    "supermaven-inc/supermaven-nvim",
    opts = {
      disable_keymaps = true,
      disable_inline_completion = true,
    },
  },

  -- Copilot setup
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },

  -- Luasnip setup
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    config = function(_, opts)
      require("luasnip").config.set_config(opts)

      -- Load friendly snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Load custom snippets if they exist
      local custom_snippets_path = vim.fn.stdpath("config") .. "/snippets"
      if vim.fn.isdirectory(custom_snippets_path) == 1 then
        require("luasnip.loaders.from_vscode").lazy_load({
          paths = { custom_snippets_path },
        })
      end
    end,
  },

  -- LSP capabilities setup for blink.cmp
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    opts = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      return {
        servers = {
          -- Add your LSP servers here
          lua_ls = {},
          pyright = {},
          ts_ls = {},
          -- Add more servers as needed
        },
        setup = {
          -- Default setup function
          ---@param server_name string
          ---@param opts table
          ["*"] = function(server_name, opts)
            opts.capabilities = capabilities
          end,
        },
      }
    end,
    config = function(_, opts)
      -- Setup servers
      for server_name, server_opts in pairs(opts.servers) do
        if opts.setup["*"] then
          opts.setup["*"](server_name, server_opts)
        end
        vim.lsp.config(server_name, server_opts)
      end
    end,
  },
}
