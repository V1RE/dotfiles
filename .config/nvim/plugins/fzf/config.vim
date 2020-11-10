" Set layout to center floating window
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5  } }
" let g:fzf_layout = {'down':'40%'}

" Setup options
" let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline --ansi --preview "bat --color=always --style=header,grid --line-range :300 {}" --bind "ctrl-j:preview-down,ctrl-k:preview-up"'
let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline --ansi --bind "ctrl-j:preview-down,ctrl-k:preview-up"'

" Setup ripgrep command
let $FZF_DEFAULT_COMMAND='rg --files --hidden --smart-case --hidden --glob "!{.git,node_modules}"'

" Make Rg a command
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --hidden --glob "!{.git,node_modules}" '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" Make function for listing buffers
function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

" Make function to close selected buffers
function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

" Make command for showing buffers and closing them on select
command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
