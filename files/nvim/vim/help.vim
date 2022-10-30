""" Help window
" - ESC closes the window
function! s:help_win()
  nnoremap <buffer><silent> <ESC> :helpclose<CR>
endfunction

augroup HelpWin
  autocmd FileType help call s:help_win()
augroup END
