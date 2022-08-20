local ls = require("LuaSnip")

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
  return function()
    if ls.jumpable(dir) then
      ls.jump(dir)
    end
  end
end

vim.keymap.set({ "i", "s" }, "<c-k>", jump(1), { silent = true })
vim.keymap.set({ "i", "s" }, "<c-j>", jump(-1), { silent = true })

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

ls.add_snippets("all", {
  s("styles", t('import * as Styles from "./"')),
})
