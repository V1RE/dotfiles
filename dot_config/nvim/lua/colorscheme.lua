vim.cmd([[
try
  colorscheme nitepal
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry

hi HopNextKey guifg=#ff9900
hi HopNextKey1 guifg=#ff9900
hi HopNextKey2 guifg=#ff9900
]])
