" fzf plugin

  " <C-a> selects all entries in an fzf window
  let $FZF_DEFAULT_OPTS='--bind ctrl-a:select-all,ctrl-d:deselect-all'

  nnoremap <silent> <c-p> :Files<CR>
  nnoremap <silent> <leader>b :Buffers<CR>

  " Rg with arguments
  " (https://github.com/junegunn/fzf.vim/issues/838#issuecomment-509902575)
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \ "rg --column --line-number --no-heading --color=always --smart-case ".<q-args>,
    \ 1, fzf#vim#with_preview(), <bang>0
    \ )

  " use fzf as 'split windows', not as 'project drawer'
  " open fzf pane in current buffer window, not in whole tab
  let g:fzf_layout={'window': '20split enew'}

  augroup FzfSettings
    autocmd!
    " ESC closes the window
    autocmd FileType fzf tnoremap <buffer> <ESC> <C-C>
  augroup END
