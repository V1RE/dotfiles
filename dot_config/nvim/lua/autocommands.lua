vim.cmd([[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd =
  augroup end

  augroup _lsp
    autocmd!
    autocmd FileType plist set ft=xml
    autocmd BufReadPost Podfile,Appfile,Fastfile,Matchfile,Pluginfile set ft=ruby
    autocmd BufReadPost *.ejs.t set ft=embedded_template
    autocmd BufReadPost *.hbs set ft=html
  augroup end
]])
