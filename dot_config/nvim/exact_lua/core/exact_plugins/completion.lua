---@type LazyPluginSpec[]
local M = {
  {
    "saghen/blink.cmp",
    lazy = false, -- lazy loading handled internally
    dependencies = {
      "rafamadriz/friendly-snippets",
      {
        "saghen/blink.compat",
        version = "*",
        optional = true,
        opts = {},
      },
    },
    version = "*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
        ["<C-space>"] = { "show", "show_documentation" },
      },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      sources = {
        completion = {
          enabled_providers = { "lsp", "path", "snippets", "buffer" },
        },
        providers = {
          path = {
            max_items = 3,
          },
          snippets = {
            max_items = 3,
          },
        },
      },

      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },

        menu = {
          draw = {
            treesitter = true,
          },
        },

        list = {
          selection = "auto_insert",
        },

        accept = {
          auto_brackets = { enabled = false },
        },
      },
    },

    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
    },

    ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
    config = function(_, opts)
      -- setup compat sources
      local enabled = opts.sources.completion.enabled_providers
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end

      -- Unset custom prop to pass blink.cmp validation
      opts.sources.compat = nil

      -- check if we need to override symbol kinds
      for _, provider in pairs(opts.sources.providers or {}) do
        ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
        if provider.kind then
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1

          CompletionItemKind[kind_idx] = provider.kind
          ---@diagnostic disable-next-line: no-unknown
          CompletionItemKind[provider.kind] = kind_idx

          ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
          local transform_items = provider.transform_items
          ---@param ctx blink.cmp.Context
          ---@param items blink.cmp.CompletionItem[]
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = kind_idx or item.kind
            end
            return items
          end

          -- Unset custom prop to pass blink.cmp validation
          provider.kind = nil
        end
      end

      require("blink.cmp").setup(opts)
    end,
  },

  -- Codeium Blink cmp source
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      {
        "Exafunction/codeium.nvim",
        cmd = "Codeium",
        build = ":Codeium Auth",
        opts = {},
      },
      "saghen/blink.compat",
    },
    opts = {
      sources = {
        compat = { "codeium" },
        ---@type table<string, blink.cmp.SourceProviderConfig>
        providers = {
          codeium = {
            kind = "Codeium",
            score_offset = 100,
            async = true,
            max_items = 1,
          },
        },
      },
    },
  },

  -- Supermaven Blink cmp source
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      {
        "supermaven-inc/supermaven-nvim",
        opts = {
          disable_keymaps = true,
          disable_inline_completion = true,
          ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
        },
      },
      "saghen/blink.compat",
    },
    opts = {
      sources = {
        compat = { "supermaven" },
        providers = {
          supermaven = {
            kind = "Supermaven",
            score_offset = 100,
            async = true,
            max_items = 1,
          },
        },
      },
    },
  },

  {
    "catppuccin",
    optional = true,
    opts = {
      integrations = { blink_cmp = true },
    },
  },
}

---@type LazyPluginSpec[]
---@diagnostic disable-next-line: unused-local
local oldCmp = {
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
    },
    ---@return cmp.Config
    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()

      ---@type cmp.ConfigSchema
      local config = {
        completion = {
          completeopt = "menu,menuone,noselect,noinsert",
        },
        preselect = cmp.PreselectMode.None,
        mapping = {
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete({}), { "i", "c" }),
          ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false })),
          ["<C-y>"] = cmp.mapping(cmp.mapping.confirm({ select = true })),
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        formatting = {
          format = function(entry, vim_item)
            local i = require("config.icons")

            vim_item.menu = vim_item.kind
            vim_item.kind = i[vim_item.kind]

            if entry.source.name == "cmp_tabnine" then
              vim_item.kind = i.Robot
              vim_item.menu = "Tabnine"
            end

            if entry.source.name == "copilot" then
              vim_item.kind = i.Copilot
              vim_item.menu = "Copilot"
            end

            if entry.source.name == "codeium" then
              vim_item.kind = " "
              vim_item.menu = "Codeium"
            end

            if entry.source.name == "supermaven" then
              vim_item.kind = " "
              vim_item.menu = "Supermaven"
            end

            return vim_item
          end,
        },
        sorting = defaults.sorting,
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      }

      return config
    end,

    ---@param opts cmp.ConfigSchema
    config = function(_, opts)
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end

      local cmp = require("cmp")
      cmp.setup(opts)

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })
    end,
  },

  -- codeium cmp source
  {
    "nvim-cmp",
    dependencies = {
      {
        "Exafunction/codeium.nvim",
        cmd = "Codeium",
        build = ":Codeium Auth",
        opts = {},
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, 1, {
        name = "codeium",
        group_index = 1,
        priority = 100,
        max_item_count = 3,
      })
    end,
  },

  -- supermaven cmp source
  {
    "nvim-cmp",
    dependencies = {
      {
        "supermaven-inc/supermaven-nvim",
        opts = { disable_keymaps = true, disable_inline_completion = true },
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, 1, {
        name = "supermaven",
        group_index = 1,
        priority = 100,
        max_item_count = 3,
      })
    end,
  },

  -- copilot cmp source
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
  {
    "nvim-cmp",
    dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        dependencies = "copilot.lua",
        opts = {},
        config = function(_, opts)
          local copilot_cmp = require("copilot_cmp")
          copilot_cmp.setup(opts)
          -- attach cmp source whenever copilot attaches
          -- fixes lazy-loading issues with the copilot cmp source
          require("core.util").on_attach(function()
            copilot_cmp._on_insert_enter({})
          end)
        end,
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, 1, {
        name = "copilot",
        group_index = 1,
        priority = 100,
      })
    end,
  },
}

return M
