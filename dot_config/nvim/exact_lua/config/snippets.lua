require("luasnip.session.snippet_collection").clear_snippets("typescriptreact")

local ls = require("luasnip")

local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local s = ls.snippet
local c = ls.choice_node
local d = ls.dynamic_node
local i = ls.insert_node
local t = ls.text_node
local sn = ls.snippet_node

ls.add_snippets("typescriptreact", {
  s(
    "edp",
    fmta(
      [[
export default function <name>Page({ params }: <props>PageProps) {
  setRequestLocale(params.locale);

  return (
    <finish>
  );
}
  ]],
      {
        name = i(1, "Example"),
        props = rep(1),
        finish = i(0),
      }
    )
  ),
})
