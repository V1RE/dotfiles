local cmp_ok, cmp = pcall(require, "cmp")
local ls_ok, ls = pcall(require, "luasnip")
local lslfvsc_ok, lslfvsc = pcall(require, "luasnip/loaders/from_vscode")

if not (cmp_ok and ls_ok and lslfvsc_ok) then
	return
end

lslfvsc.lazy_load()

local i = require("config.icons")

cmp.setup({
	snippet = {
		expand = function(args)
			ls.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
		["<Tab>"] = cmp.mapping.select_next_item(),
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

			return vim_item
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "path" },
		{ name = "copilot" },
		{ name = "cmp_tabnine", max_item_count = 3 },
		{ name = "luasnip", max_item_count = 3 },
		{ name = "buffer", max_item_count = 5 },
		{ name = "emoji" },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	experimental = {
		ghost_text = true,
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
