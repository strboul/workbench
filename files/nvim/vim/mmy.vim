" M.Y.'s custom vim commands

" ----- Utils ------------------------------------------------------------

" Get character under the cursor (https://vi.stackexchange.com/a/19709/)
  function mmy#GetCharUnderCursor()
    return strcharpart(strpart(getline('.'), col('.') - 1), 0, 1)
  endfunction

" ----- Functions --------------------------------------------------------
" Get git ignored files as a list (if the current wd is a git repository)
  function mmy#GetGitIgnoredFiles()
    let l:git_ignored=system('git status --ignored --porcelain')
    let l:ignored_text=matchstr(l:git_ignored, '!!.*')
    let l:text=substitute(l:ignored_text, '!!', '', 'g')
    let l:text=substitute(l:text, '/', '', 'g')
    let l:sp=split(l:text, '\n')
    let l:esc_tail=map(copy(l:sp), 'escape(fnamemodify(trim(v:val), ":t"), ".")')
    let l:out=uniq(l:esc_tail)
    return l:out
  endfunction

" ----- Commands ---------------------------------------------------------

" Echo buffer file path and put them in the register
  function mmy#EchoRegisterBufferPath()
    let l:abs_pat=expand('%:p')
    let l:rel_pat=expand('%')
    if l:abs_pat !=# ''
      call setreg('f', l:abs_pat)
      call setreg('g', l:rel_pat)
      echohl Statement |echon printf('%s  ', l:rel_pat) | echohl None
      echon '(relative)'
      echohl Statement |echon printf('  %s  ', l:abs_pat) | echohl None
      echon '(absolute); paths stored in :reg '
      echohl Statement | echon ' "g  ' | echohl None
      echon 'and '
      echohl Statement | echon ' "f  ' | echohl None
      echon 'respectively'
    else
      echohl WarningMsg | echo 'No file in the buffer' | echohl None
    endif
  endfunction

  command EchoRegisterBufferPath :call mmy#EchoRegisterBufferPath()
  nnoremap <silent> <C-g> :EchoRegisterBufferPath<CR>


" Convert single quotes to double and vice versa
" FIXME: doesn't work well sometimes
  function mmy#QuoteTypesToggle()
    " (maybe write this fun recursively one day)
    " get the cursor position:
    let l:init_cur_pos=getpos('.')
    let l:init_char=mmy#GetCharUnderCursor()
    normal! f"
    let l:char_after_double=mmy#GetCharUnderCursor()
    if l:init_char == l:char_after_double
      normal! f'
      let l:char_after_single=mmy#GetCharUnderCursor()
      if l:init_char == l:char_after_single
        echohl WarningMsg | echo 'No quotes found around' | echohl None
      else
        normal! r"F'r"
      endif
    else
      normal! r'F"r'
    endif
    " restore the initial cursor position:
    call setpos('.', l:init_cur_pos)
  endfunction

  command QuoteTypesToggle :call mmy#QuoteTypesToggle()


" Command to help fix indentation lines
  function mmy#IndentToggle()
    if &cursorcolumn | set nocursorcolumn | else | set cursorcolumn | endif
    if &list         | set nolist         | else | set list         | endif
  endfunction

  command IndentToggle :call mmy#IndentToggle()


" Break into new lines by (,) comma e.g. `[x=1, y=2, c=3]`
" TODO create SplitIntoMultipleLines instead with a prompt for delimiter
" TODO this can be written in a LUA.
  function mmy#SpanLinesByComma()
    " vint: -ProhibitCommandWithUnintendedSideEffect -ProhibitCommandRelyOnUser
    :s/,/,\r/g
    " vint: +ProhibitCommandWithUnintendedSideEffect +ProhibitCommandRelyOnUser
    " keep cursor position on the line
    normal! ``
  endfunction

  command SpanLinesByComma :call mmy#SpanLinesByComma()


" Search & highlight non-ASCII chars (https://stackoverflow.com/a/16987522)
  function mmy#SearchNonASCIIChars()
    " built query as <CR> isn't read between double quotes, see:
    " https://vim.fandom.com/wiki/Using_normal_command_in_a_script_for_searching
    let l:query='/[^\x00-\x7F]'
    execute 'normal! /' . l:query . "\<CR>"
  endfunction

  command SearchNonASCIIChars :call mmy#SearchNonASCIIChars()


" Remove zero width unicode chars displayed as <200b>
  function mmy#RemoveZeroWidthSpaceChars()
    " vint: -ProhibitCommandWithUnintendedSideEffect -ProhibitCommandRelyOnUser
    :%s/\%u200b//g
    " vint: +ProhibitCommandWithUnintendedSideEffect +ProhibitCommandRelyOnUser
  endfunction

  command RemoveZeroWidthSpaceChars :call mmy#RemoveZeroWidthSpaceChars()


" Find todo keywords (case sensitive) in dirs and open them in a quickfix window
  function mmy#TODOFind()
    try
      " TODO add an alternative for non git repos
      silent vimgrep /TODO\|FIXME\|XXX\C/g `git ls-files`
    catch /^Vim\%((\a\+)\)\=:E480/ " catch error E480 - No match
      echohl WarningMsg | echo 'No TODOs found.' | echohl None
      return
    endtry
    :BD " from vim-bufkill plugin
    copen
  endfunction

  command TODOFind :call mmy#TODOFind()


" Get name of the vim highlight name under the cursor
  function mmy#GetVimHighlightNameUnderCursor()
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  endfunction

  command GetVimHighlightNameUnderCursor :call mmy#GetVimHighlightNameUnderCursor()

" Reverse the order of visual selected lines
  function mmy#ReverseSelectedLines()
    " `tac` is a program from `coreutils`:
    " https://man.archlinux.org/man/tac.1.en
    '<,'>!tac
  endfunction

  command -range ReverseSelectedLines :call mmy#ReverseSelectedLines()

lua << EOF
--[[
Read variables from a simple config file, where the variables are expressed in
the following way:

  KEY=VALUE

where single (') or double (") quotes are optional around VALUE.
--]]
DEFAULT_CONFIG_PATH='/opt/workbench/variables'
function _G.mmy_GetLocalConfigVariable(var, config_path)
  config_path = config_path or DEFAULT_CONFIG_PATH
  file = io.open(config_path, 'rb')
  if not file then return nil end
  lines = file:lines()
  for line in lines do
    t = {}
    for str in string.gmatch(line, '[^=]+') do
      table.insert(t, str)
    end
    key=t[1]
    value=t[2]
    if key == var and value ~= nil then
      -- replace any extra quotes
      value = value:gsub('\'', ''):gsub('\"', '')
      return value
    end
  end
  file:close()
  return nil
end
EOF

lua << EOF
--[[
Copy a visual selection with markdown compatible output.
It can help for literal programming.
--]]
function _G.mmy_CopyWithMetadata()
  -- get visual selection range
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
  -- get buffer lines by range
  local buf_lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  local linestr = table.concat(buf_lines, "\n")
  local selected = table.concat({"```", linestr, "```"}, "\n")
  -- get path
  local current_dir = vim.fn.fnamemodify(vim.loop.cwd(), ":t")
  local current_bufname = vim.fn.expand('%')
  local path = table.concat({current_dir, "/", current_bufname})
  -- row numbers
  local row_nums
  if start_row == end_row then
    row_nums = start_row
  else
    row_nums = table.concat({start_row, "-", end_row})
  end
  -- file identifier
  local file_id = table.concat({"> ", path, ":", row_nums})
  -- save to register
  local out = table.concat({file_id, selected}, "\n")
  print(out)
  vim.fn.setreg('+', out)
end
EOF

function! mmy#CopyWithMetadata()
  return v:lua.mmy_CopyWithMetadata()
endfunction

command -range CopyWithMetadata :call mmy#CopyWithMetadata()
