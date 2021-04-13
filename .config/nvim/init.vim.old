let mapleader = ' '

source ~/.config/nvim/plugins.vim
source ~/.config/nvim/mappings.vim

if exists('g:vscode')
  source ~/.config/nvim/vscode/settings.vim
else
  source ~/.config/nvim/nvim.vim
  source ~/.config/nvim/plugins/Defx/config.vim
  source ~/.config/nvim/plugins/fzf/config.vim
  source ~/.config/nvim/plugins/vimsence/config.vim
  source ~/.config/nvim/plugins/whichkey/config.vim
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
colorscheme sonokai
set number
set ignorecase
set smartcase
set encoding=utf-8
set splitbelow
set splitright
set autoread
set virtualedit=onemore

let g:airline_powerline_fonts = 1
let g:airline_theme = 'molokai'
let g:airline#extensions#tabline#enabled = 1

let g:floaterm_autoclose = 1

let g:gitgutter_map_keys = 0

let g:neovide_cursor_vfx_mode = "railgun"

let php_htmlInStrings = 1

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction



command! -nargs=0 Prettier :CocCommand prettier.formatFile

if has("autocmd")
  filetype plugin indent on

  autocmd BufReadPost * " {{{2
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif "}}}2
  autocmd BufWritePre * :%s/\s\+$//e
  autocmd BufWritePre *.svelte :Prettier
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

