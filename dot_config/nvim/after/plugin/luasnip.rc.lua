local ls = require("luasnip")

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
local t = ls.text_node

ls.add_snippets("all", {
  s("styles", t('import * as Styles from "./"')),
})
