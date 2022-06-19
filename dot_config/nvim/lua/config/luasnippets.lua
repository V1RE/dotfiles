local status_ok, ls = pcall(require, "luasnip")
if not status_ok then
	return
end

--
-- local s = ls.snippet
-- local i = ls.insert_node
-- local fmt = require("luasnip.extras.fmt")
--
-- ls.add_snippets("all", {
--   s("clg", {
--     fmt("console.log({});", { i(1) }),
--   }),
-- })

local function jump(dir)
	if ls.jumpable(dir) then
		return function()
			ls.jump(dir)
		end
	end
end

vim.keymap.set({ "i", "s" }, "<c-k>", jump(1), { silent = true })
vim.keymap.set({ "i", "s" }, "<c-j>", jump(-1), { silent = true })
