" fugitive plugin

  function! s:fugitivegit_ft()
    setlocal nolist
    setlocal colorcolumn=
    setlocal winhighlight=Normal:SignColumn
  endfunction

  " - ESC closes the window
  function! s:fugitiveblame_ft()
    nnoremap <buffer><silent> <ESC> :q<CR>
  endfunction

  augroup FugitiveWins
    autocmd FileType fugitiveblame call s:fugitiveblame_ft()
    autocmd FileType git call s:fugitivegit_ft()
  augroup END
