set nocompatible
filetype off
set shell=zsh

source ~/.config/nvim/plugins.vim

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

let mapleader = ' '

noremap H 5h
noremap J 5j
noremap K 5k
noremap L 5l
nnoremap ; :
vnoremap ; :
nnoremap \ :set hlsearch!<CR>
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
inoremap jj <ESC>
tnoremap jj <C-\><C-n>
nnoremap <leader>i :so ~/.config/nvim/init.vim<CR>
nnoremap <leader>o :e ~/.config/nvim/init.vim<CR>
nnoremap <leader>p :PlugInstall<CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>t :terminal<CR>
nnoremap <leader>T :FloatermToggle<CR>
nnoremap <leader>n :call DefxTree()<CR>
nnoremap <leader>N :Defx -toggle=0 -resume -search=`expand('%:p')`<CR>zz
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>F :Rg<CR>
nnoremap <leader>q :bp<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>e :bn<CR>
nnoremap <leader>d :bp<cr>:bd #<cr>
nnoremap <leader>D :BD<cr>
nnoremap <leader>gs :G<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>/ :Commentary<CR>
vnoremap <leader>/ :Commentary<CR>
nnoremap <silent> <leader> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>
nnoremap <leader><leader> :call <SID>show_documentation()<CR>

"Select lines after indent
vmap > >gv
vmap < <gv

let g:airline_powerline_fonts = 1
let g:airline_theme = 'molokai'
let g:airline#extensions#tabline#enabled = 1

let g:floaterm_autoclose = 1

let g:neovide_cursor_vfx_mode = "railgun"

let php_htmlInStrings = 1

let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }

let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline'
let $FZF_DEFAULT_COMMAND='rg --files --hidden --smart-case --hidden --glob "!{.git,node_modules}"'
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --hidden --glob "!{.git,node_modules}" '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))

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
	autocmd FileType defx call s:defx_my_settings()
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

autocmd BufWrite * call defx#do_action('redraw')

function! DefxTree() abort
  call s:defx_option_tree()
  :Defx
endfunction

function! s:defx_option_tree() abort
  call defx#custom#option('_', {
    \ 'columns': 'git:indent:icons:filename:size:time',
    \ 'winwidth': 30,
    \ 'split': 'vertical',
    \ 'direction': 'topleft',
    \ 'show_ignored_files': 0,
    \ 'ignored_files':'.*,*.png,*.hdr,bin,pkg',
    \ 'buffer_name': 'defx_tree',
    \ 'toggle': 1,
    \ 'resume': 1,
    \ })
endfunction

function! s:defx_my_settings() abort
  setl cursorline
  setl nospell
  setl nonumber
  setl signcolumn=yes
  nnoremap <silent><buffer><expr> <CR>
  \ defx#is_directory() ?
  \ defx#do_action('open_or_close_tree') : defx#do_action('drop',)
  nnoremap <silent><buffer><expr> c
  \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
  \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
  \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> l
  \ defx#is_directory() ?
  \ defx#do_action('open') : defx#do_action('drop',)
  nnoremap <silent><buffer><expr> E
  \ defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> P
  \ defx#do_action('preview')
  nnoremap <silent><buffer><expr> o
  \ defx#do_action('open_tree', 'toggle')
  nnoremap <silent><buffer><expr> N
  \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M
  \ defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> C
  \ defx#do_action('toggle_columns',
  \                'mark:indent:icon:filename:type:size:time')
  nnoremap <silent><buffer><expr> S
  \ defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> d
  \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
  \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> !
  \ defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x
  \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
  \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
  \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> h
  \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
  \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
  \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
  \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
  \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j
  \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
  \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l>
  \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
  \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
  \ defx#do_action('change_vim_cwd')
endfunction
