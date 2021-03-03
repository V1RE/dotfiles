noremap H 5h
noremap J 5j
noremap K 5k
noremap L 5l
nnoremap ; :
vnoremap ; :
nnoremap <leader>p :PlugInstall<CR>

if exists('g:vscode')
  source ~/.config/nvim/vscode/mappings.vim
else
  nnoremap <leader>h <C-w>h
  nnoremap <leader>j <C-w>j
  nnoremap <leader>k <C-w>k
  nnoremap <leader>l <C-w>l
  nnoremap \ :set hlsearch!<CR>
  inoremap jj <ESC>
  nnoremap <leader>n :call DefxTree()<CR>
  nnoremap <leader>N :Defx -toggle=0 -resume -search=`expand('%:p')`<CR>zz
  nnoremap <leader>i :so ~/.config/nvim/init.vim<CR>
  nnoremap <leader>o :e ~/.config/nvim/init.vim<CR>
  nnoremap <leader>b :Buffers<CR>
  nnoremap <leader>f :Files<CR>
  nnoremap <leader>F :Rg<CR>
  nnoremap <leader>w :w<CR>
  nnoremap <leader>q :bp<CR>
  " nnoremap <leader>q :BufferPrevious<CR>
  nnoremap <leader>e :bn<CR>
  " nnoremap <leader>e :BufferNext<CR>
  nnoremap <leader>d :bp<cr>:bd #<CR>
  " nnoremap <leader>d :BufferClose<CR>
  nnoremap <leader>D :BD<CR>
  nnoremap <leader>/ :Commentary<CR>
  vnoremap <leader>/ :Commentary<CR>
  nnoremap <silent> <leader> :silent WhichKey '<Space>'<CR>
  vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>
  nnoremap <leader><leader> :call <SID>show_documentation()<CR>
  nnoremap <silent> <leader>g :LazyGit<CR>
  nnoremap <leader>- :sp<CR>
  nnoremap <leader>_ :vsp<CR>
endif

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction


"Select lines after indent
vmap > >gv
vmap < <gv
