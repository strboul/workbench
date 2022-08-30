" lightline plugin
  let g:lightline = {
    \ 'colorscheme': 'one',
    \ 'active': {
    \   'left': [
    \     [ 'mode', 'paste' ],
    \     [ 'sshcontent', 'foldername' ],
    \     [ 'gitbranch', 'readonly', 'filename' ]
    \   ],
    \   'right': [
    \     [ 'lineinfo' ],
    \     [ 'percent' ],
    \     [ 'fileformat', 'fileencoding', 'filetype' ]
    \   ]
    \ },
    \ 'inactive': {
    \   'left': [],
    \   'right': [ [ 'relativepath' ] ],
    \ },
    \ 'tabline': {
    \   'left': [['tabs']],
    \   'right': []
    \ },
    \ 'component_function': {
    \   'sshcontent':   'LightlineSshContent',
    \   'foldername':   'LightlineFoldername',
    \   'gitbranch':    'LightlineGitBranch',
    \   'readonly':     'LightlineReadonly',
    \   'filename':     'LightlineFilename',
    \   'fileformat':   'LightlineFileFormat',
    \   'fileencoding': 'LightlineFileEncoding',
    \ },
    \ }

  let g:lightline.separator={ 'left': "\ue0b0", 'right': "\ue0b2" }
  let g:lightline.subseparator={ 'left': "\ue0b1", 'right': "\ue0b3" }

  " Git integration
  function! LightlineGitBranch()
    if FugitiveHead() ==# ''
      return ''
    endif
    return nr2char(0x2387) . '  ' . FugitiveHead()
  endfunction

  " Hide the filetype in the help pane
  function! LightlineReadonly()
    return &readonly && &filetype !=# 'help' ? 'RO' : ''
  endfunction

lua << EOF
--[[
How foldername is shown:

  -------------
  |is_git_repo|-- No --> Nothing.
  -------------
        |
       Yes
        |
        v
  ---------------------------
  |tail_cwd == tail_git_repo|
  ---------------------------
         |             |
        Yes            No
         |             |
         v             v
  ---------------   -----------------------
  |tail_git_repo|   |tail_git_repo/subpath|
  ---------------   -----------------------

--]]
function _G.LuaLightlineFoldername()
  -- TODO: there's a bug that the FugitiveGitDir checks the file, not
  -- cwd. So if you open a git file from another non-git dir, it bugs out.
  local has_fugitive, git_dir = pcall(vim.fn['FugitiveGitDir'])
  if not has_fugitive or git_dir == '' then
    return ''
  end
  git_dir = vim.fn.fnamemodify(git_dir, ':h')
  local cwd = vim.fn.getcwd()
  local tail_git_repo = vim.fn.fnamemodify(git_dir, ':t')
  local tail_cwd = vim.fn.fnamemodify(cwd, ':t')
  if tail_git_repo == tail_cwd then
    return tail_git_repo
  end
  function sanitize_match(str)
    -- escape hyphen in match as it's special
    return string.gsub(str, '[%s-...]', '%%%0')
  end
  -- TODO: MAKE git_dir NORMAL COLOR OR BOLD AND subpath_rest PALE COLOR
  subpath = pcall(string.match(cwd, sanitize_match(git_dir) .. '/(.*)'))
  if not subpath then
    return ''
  end
  return tail_git_repo .. '/' .. subpath
end

function _G.LuaLightlineSshContent()
  local has_ssh_client = vim.loop.os_environ()['SSH_CLIENT'] == nil
  local has_ssh_connection = vim.loop.os_environ()['SSH_CONNECTION'] == nil
  if has_ssh_client or has_ssh_connection then
    return ''
  end
  local os_user = vim.loop.os_environ()['USER']
  local os_hostname = vim.loop.os_gethostname()
  -- TODO: ssh text should be different color, like pink maybe (check p10k)
  return (os_user .. '@' .. os_hostname)
end
EOF

  function! LightlineFoldername()
    return v:lua.LuaLightlineFoldername()
  endfunction

  function! LightlineSshContent()
    return v:lua.LuaLightlineSshContent()
  endfunction

  " Hide the filename in
  " - the help pane
  " - terminal
  " Show the relative path filename.
  function! LightlineFilename()
    if &buftype ==# 'help'
      return 'help'
    elseif &buftype ==# 'terminal'
      return expand('%:t')
    elseif expand('%:t') !=# ''
      return expand('%')
    else
      return '[No Name]'
    endif
  endfunction

  " don't show file format if it's unix, check `help 'fileformat'`
  function LightlineFileFormat()
    return &fileformat ==# 'unix' ? '' : &fileformat
  endfunction

  " don't show file encoding if it's utf-8
  function LightlineFileEncoding()
    return &fileencoding ==# 'utf-8' ? '' : &fileencoding
  endfunction
