---@type LazyPluginSpec[]
local M = {
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
      "saadparwaiz1/cmp_luasnip",
    },
    ---@return cmp.Config
    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()

      ---@type cmp.ConfigSchema
      local config = {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        preselect = cmp.PreselectMode.None,
        mapping = {
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete({}), { "i", "c" }),
          ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false })),
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
        experimental = {
          ghost_text = true,
        },
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
}

return M
