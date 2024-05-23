local cmp = require("cmp")
local ls = require("luasnip")
local i = require("config.icons")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      ls.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item()),
    ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item()),
    ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete({}), { "i", "c" }),
    ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false })),
    ["<Tab>"] = cmp.mapping(function()
      ls.jump(1)
    end),
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
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
  sources = {
    { name = "supermaven", group_index = 2, max_item_count = 3, priority = 100 },
    { name = "codeium", group_index = 2, max_item_count = 3, priority = 100 },
    { name = "nvim_lsp", group_index = 2, max_item_count = 15, priority = 90 },
    { name = "path", group_index = 2 },
    { name = "luasnip", group_index = 2, max_item_count = 5 },
    { name = "cmp_tabnine", group_index = 2, max_item_count = 3, priority = 10 },
    { name = "copilot", group_index = 2, max_item_count = 3, priority = 10 },
    { name = "buffer", group_index = 5 },
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  formatters = {
    insert_text = require("copilot_cmp.format").remove_existing,
  },
  sorting = {
    priority_weight = 1,
    comparators = {
      cmp.config.compare.exact,
      require("copilot_cmp.comparators").prioritize,
      require("copilot_cmp.comparators").score,
      cmp.config.compare.offset,
      -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
      cmp.config.compare.score,
      -- cmp.config.compare.recently_used,
      -- cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

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
