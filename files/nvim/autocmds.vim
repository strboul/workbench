" ----- Essential autocommands ---------------------------------------------

" Auto save on focus out (but not in insert-mode, which is by `CursorHoldI`).
" (https://github.com/justinforce/dotfiles/blob/master/files/nvim/init.vim#L82)
  augroup AutoSaveBuffer
    autocmd BufLeave,CursorHold,FocusLost * silent! wa
  augroup END

" Trigger autoread when changing buffers or coming back to vim.
" (https://stackoverflow.com/a/20418591)
  augroup AutoreadOnBufferChange
    autocmd FocusGained,BufEnter * :silent! !
  augroup END

" Smarter cursorline (enabled only in the Normal mode)
  augroup CursorlineOnNormalMode
    autocmd InsertLeave,WinEnter * setlocal cursorline
    autocmd InsertEnter,WinLeave * setlocal nocursorline
  augroup END

" Restore cursor position when opening file (from :marks)
  augroup RestoreLastCursorPosition
    autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   execute "normal! g`\"" |
      \ endif
  augroup END

" Notification after file change (https://vi.stackexchange.com/a/13093)
  augroup MessageIfFileChangedOutsideBuffer
    autocmd FileChangedShellPost *
      \ echohl WarningMsg |
      \ echo "File changed on disk. Buffer reloaded." |
      \ echohl None
  augroup END

" Keep yanked text highlighted for a given time
  augroup HighlightYankedText
    autocmd!
    autocmd TextYankPost * silent!
      \ lua vim.highlight.on_yank {higroup='IncSearch', timeout=1500}
  augroup END
