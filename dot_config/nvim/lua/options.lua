--- @type vim.opt
local options = {
  autoread = true,
  backup = false,
  clipboard = "unnamedplus",
  cmdheight = 1,
  completeopt = { "menuone", "noselect" },
  conceallevel = 0,
  cursorline = true,
  expandtab = true,
  fileencoding = "utf-8",
  foldexpr = "nvim_treesitter#foldexpr()",
  foldlevelstart = 999,
  foldmethod = "expr",
  guifont = "FiraCode Nerd Font:h16",
  hlsearch = true,
  ignorecase = true,
  laststatus = 3,
  mouse = "a",
  number = true,
  numberwidth = 4,
  pumheight = 10,
  relativenumber = true,
  scrolloff = 8,
  shiftwidth = 2,
  showmode = false,
  showtabline = 0,
  sidescrolloff = 5,
  signcolumn = "yes",
  smartcase = true,
  smartindent = true,
  splitbelow = true,
  splitright = true,
  swapfile = false,
  tabstop = 2,
  termguicolors = true,
  timeoutlen = 200,
  undofile = true,
  updatetime = 300,
  wrap = false,
  writebackup = false,
  list = true,
  listchars = vim.opt.listchars .. ",trail:·",
  shortmess = vim.opt.shortmess .. "c",
  whichwrap = vim.opt.whichwrap .. ",<,>,[,],h,l",
  iskeyword = vim.opt.iskeyword .. "-",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.g.markdown_fenced_languages = {
  "ts=typescript",
}

vim.cmd([[set formatoptions-=cro]])
