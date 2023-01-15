-- " Highlight word under cursor without jumping to next or prev occurrence
-- " https://github.com/scrooloose/vimfiles/blob/a9689e8eace5b38d9fb640294e6e4b681e18981a/vimrc#L497-L509
--   nnoremap <silent> * :let @/='\V\<'.escape(expand('<cword>'), '\').'\>'<CR>:set hls<CR>
--   nnoremap <silent> # :let @/='\V\<'.escape(expand('<cword>'), '\').'\>'<CR>:set hls<CR>
--
--   " visual selection search with */#
--   function! s:VSelectSearch()
--     let temp=@@
--     normal! gvy
--     let @/='\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
--     let @@=temp
--   endfunction
--
--   vnoremap <silent> * :<C-u>call <SID>VSelectSearch()<CR>:set hls<CR>
--   vnoremap <silent> # :<C-u>call <SID>VSelectSearch()<CR>:set hls<CR>

-- TODO:
-- multi color search and highlight.
-- search: `2*`, `3*`, ... or `2#`, `3#`, ...
-- next: `2n`, `3n`, ...
-- previous: `2N`, `3N`, ...
