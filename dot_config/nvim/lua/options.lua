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
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.shortmess:append("c")
vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.listchars:append("trail:·")

vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]])
