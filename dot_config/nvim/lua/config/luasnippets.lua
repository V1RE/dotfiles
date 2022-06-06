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

-- <c-k> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
vim.keymap.set({ "i", "s" }, "<c-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

-- <c-j> is my jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<c-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })
