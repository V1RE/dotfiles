let mapleader = ' '

source ~/.config/nvim/plugins.vim
source ~/.config/nvim/mappings.vim

if exists('g:vscode')
  source ~/.config/nvim/vscode/settings.vim
else
  source ~/.config/nvim/nvim.vim
  source ~/.config/nvim/plugins/Defx/config.vim
  source ~/.config/nvim/plugins/fzf/config.vim
endif

set nocompatible
filetype off
set shell=zsh
set tabstop=2
set shiftwidth=2
set expandtab
set cursorline
set title
set cmdheight=1
set updatetime=300
set shortmess+=c
set signcolumn=yes
set termguicolors
set scrolloff=5
set hidden
syntax on
set t_Co=256
set guifont=FuraCode\ Nerd\ Font:h14
set background=dark
colorscheme onedark
set number
set ignorecase
set smartcase
set encoding=utf-8
set splitbelow
set splitright
set mouse=a
set autoread

let g:airline_powerline_fonts = 1
let g:airline_theme = 'molokai'
let g:airline#extensions#tabline#enabled = 1

let g:floaterm_autoclose = 1

let g:neovide_cursor_vfx_mode = "railgun"

let php_htmlInStrings = 1

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
let g:which_key_map['q'] = [ ':bp'       , 'previous tab' ]
let g:which_key_map['e'] = [ ':bn'       , 'next tab' ]
let g:which_key_map['d'] = [ ':bp<cr>:bd #'       , 'close tab' ]
let g:which_key_map['/'] = [ '<Plug>NERDCommenterToggle'  , 'comment' ]
let g:which_key_map['k'] = [ '<C-w>k'  , 'move ↑' ]
let g:which_key_map['j'] = [ '<C-w>j'  , 'move ↓' ]
let g:which_key_map['h'] = [ '<C-w>h'  , 'move ←' ]
let g:which_key_map['l'] = [ '<C-w>l'  , 'move →' ]
let g:which_key_map['i'] = [ ':so ~/.config/nvim/init.vim'  , 'source init' ]
let g:which_key_map['o'] = [ ':e ~/.config/nvim/init.vim'  , 'open init' ]
let g:which_key_map['p'] = [ ':PlugInstall'  , 'install plugins' ]
let g:which_key_map['u'] = [ ':UndotreeShow'  , 'undotree' ]
let g:which_key_map['t'] = [ ':terminal'  , 'terminal' ]
let g:which_key_map['T'] = [ ':FloatermToggle'  , 'floaterm' ]
let g:which_key_map['n'] = [ ':call DefxTree()'  , 'files sidebar' ]
" let g:which_key_map['N'] = [ ':NERDTreeFind'  , 'find current file' ]
let g:which_key_map['b'] = [ ':Buffers'  , 'list buffers' ]
let g:which_key_map['f'] = [ ':Files'  , 'find files' ]
let g:which_key_map['F'] = [ ':Rg'  , 'find text' ]
let g:which_key_map['D'] = [ ':BD'  , 'close buffers' ]

" Register which key map
call which_key#register('<Space>', "g:which_key_map")

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

command! -nargs=0 Prettier :CocCommand prettier.formatFile

if has("autocmd")
  filetype plugin indent on

  autocmd BufReadPost * " {{{2
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif "}}}2
  autocmd BufWritePre * :%s/\s\+$//e
  autocmd BufRead,BufNewFile COMMIT_EDITMSG set textwidth=0
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .eslintrc,.jscsrc,.jshintrc,.babelrc set ft=json
  autocmd BufRead,BufNewFile gitconfig set ft=.gitconfig
  autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
  autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
endif

if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif

