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
