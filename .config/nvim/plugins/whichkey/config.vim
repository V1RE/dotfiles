" Create map to add keys to
let g:which_key_map =  {}
" Define a separator
let g:which_key_sep = '→'
" set timeoutlen=100

" Not a fan of floating windows for this
let g:which_key_use_floating_win = 0

" Change the colors if you want
highlight default link WhichKey          Operator
highlight default link WhichKeySeperator DiffAdded
highlight default link WhichKeyGroup     Identifier
highlight default link WhichKeyDesc      Function

" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

" Single mappings
let g:which_key_map['w'] = [ ':w'       , 'save file' ]
let g:which_key_map['q'] = [ ':BufferPrevious'       , 'previous tab' ]
let g:which_key_map['e'] = [ ':BufferNext'       , 'next tab' ]
let g:which_key_map['d'] = [ ':BufferClose'       , 'close tab' ]
let g:which_key_map['/'] = [ '<Plug>NERDCommenterToggle'  , 'comment' ]
let g:which_key_map['k'] = [ '<C-w>k'  , 'move ↑' ]
let g:which_key_map['j'] = [ '<C-w>j'  , 'move ↓' ]
let g:which_key_map['h'] = [ '<C-w>h'  , 'move ←' ]
let g:which_key_map['l'] = [ '<C-w>l'  , 'move →' ]
let g:which_key_map['i'] = [ ':so ~/.config/nvim/init.vim'  , 'source init' ]
let g:which_key_map['o'] = [ ':e ~/.config/nvim/init.vim'  , 'open init' ]
let g:which_key_map['p'] = [ ':PlugInstall'  , 'install plugins' ]
let g:which_key_map['n'] = [ ':call DefxTree()'  , 'files sidebar' ]
let g:which_key_map['N'] = [ ':Defx -toggle=0 -resume -search=`expand("%:p")`<CR>zz'  , 'find current file' ]
let g:which_key_map['b'] = [ ':Buffers'  , 'list buffers' ]
let g:which_key_map['f'] = [ ':Files'  , 'find files' ]
let g:which_key_map['F'] = [ ':Rg'  , 'find text' ]
let g:which_key_map['D'] = [ ':BD'  , 'close buffers' ]

" Register which key map
call which_key#register('<Space>', "g:which_key_map")
