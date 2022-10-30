:scriptencoding utf-8

source $HOME/dotfiles/files/nvim/vim/mmy.vim

" ----- General settings ---------------------------------------------------

  source $HOME/dotfiles/files/nvim/vim/essential.vim

" Window display
  set nonumber         " line numbers
  set norelativenumber " relative line numbers
  set cursorline       " horizontal cursor bar for the current line
  set laststatus=2     " always show the status bar
  set showtabline=2    " always show the tab bar
  set noshowmode       " no showmode e.g. --INSERT-- display, check statusbar
  set splitright       " always open h-splits at the right side
  set splitbelow       " always open v-splits at the below side
  set scrolloff=8      " off the lines when scrolling down, with high value keep cursor more in the center
  set signcolumn=yes   " always show signcolumn for linting, diagnostics, etc.
  set shortmess+=I     " don't give the intro message at the start `:intro`
  set ruler            " always show cursor position


" Searching
  set ignorecase       " case insensitive search
  set smartcase        " case sensitive search (if any uppercase char exists)
  set incsearch        " start matching as soon as something is typed
  set inccommand=split " preview substitution in split window (nvim specific)


" Pasting
  set nopaste                " Disable paste mode (see `:help paste`)
  set clipboard+=unnamedplus " Set system clipboard for yank/put/delete


" Indentation and spacing
  set nowrap                     " don't wrap
  set tabstop=2                  " insert 2 spaces for a tab
  set shiftwidth=2               " use 2 spaces when indenting
  set smarttab                   " tabbing detects when e.g. you have 2 or 4
  set expandtab                  " convert tab to spaces
  set smartindent                " makes indenting smart
  set autoindent                 " use indendation of previous line


" listchars
  set list                       " show listchars
  set listchars=tab:\¦\ ,space:␣
  set listchars+=trail:·


" virtual editing on the window, can do block/rectangular selections:
  set virtualedit=block


" Timeout when press on ESC to switch from Insert to Normal mode
" If use nvim with tmux, be sure tmux.conf has: `set -s escape-time 0`
  set timeout timeoutlen=1500
  " decrease <esc> key timeoutlen, default is 50
  set ttimeout ttimeoutlen=10


" Default (4000 ms ~ 4 s) is too slow. And a very low value can slow down vim.
  set updatetime=100


" darken the screen after the 80th char
  let &colorcolumn='80,'.join(range(80,999),',')


" stop continuing comments (see `:help formatoptions` and `:help fo-table`)
" FIXME doesn't work, it's a bug in vim
  " autocmd FileType * setlocal formatoptions-=cro


" essential autocommands
  source $HOME/dotfiles/files/nvim/vim/autocmds.vim

" Quickfix
  source $HOME/dotfiles/files/nvim/vim/quickfix.vim

" Help
  source $HOME/dotfiles/files/nvim/vim/help.vim

  source $HOME/dotfiles/files/nvim/vim/filetypes.vim
  source $HOME/dotfiles/files/nvim/vim/mappings.vim

" ----- Plugins ------------------------------------------------------------

" Plugins installed with vim-plug (https://github.com/junegunn/vim-plug)
"
" Specify directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Debug: - check the running paths with `:set runtimepath?`
" - Use full URL because it's easy to go to the link with `gx`
call plug#begin(stdpath('config') . '/vim-plug')

" fzf
  Plug 'https://github.com/junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'https://github.com/junegunn/fzf.vim'
  source $HOME/dotfiles/files/nvim/plugins/fzf.vim


" lightline
  Plug 'https://github.com/itchyny/lightline.vim'
  source $HOME/dotfiles/files/nvim/plugins/lightline.vim


" NERDTree
  Plug 'https://github.com/preservim/nerdtree'
  source $HOME/dotfiles/files/nvim/plugins/nerdtree.vim


" nerdcommenter
  Plug 'https://github.com/preservim/nerdcommenter'
  " add an extra space after comment symbol
  let NERDSpaceDelims=1
  let g:NERDCustomDelimiters={
    \ 'javascript': { 'left': '//', 'right': '', 'leftAlt': '{/*', 'rightAlt': '*/}' },
  \ }


" icons/patched fonts
  Plug 'https://github.com/ryanoasis/vim-devicons'


" coc.nvim
  Plug 'https://github.com/neoclide/coc.nvim', {'branch': 'release'}
  source $HOME/dotfiles/files/nvim/plugins/coc/coc.vim

" TODO: use tagbar or Vista?
" tagbar
  Plug 'https://github.com/preservim/tagbar'
  " tags should be sorted by order of their apperance, not alphabetically
  let g:tagbar_sort=0


" Vista
  Plug 'https://github.com/liuchengxu/vista.vim'


" urlview
  Plug 'https://github.com/strboul/urlview.vim'  " :Urlview


" any-jump
  Plug 'https://github.com/pechorin/any-jump.vim'  " <leader>j


" floaterm
  Plug 'https://github.com/voldikss/vim-floaterm'

  function! s:floaterm_lazygit()
    :FloatermNew lazygit
  endfunction
  command Lg :call s:floaterm_lazygit()

  source $HOME/dotfiles/files/nvim/plugins/floaterm.vim


" vim-bufkill (for :BD)
  Plug 'https://github.com/qpkorr/vim-bufkill'
  " don't let bufkill create leader mappings, use Command Mode instead:
  let g:BufKillCreateMappings=0


" vim-better-whitespace (highlight and remove trailing whitespace)
  Plug 'https://github.com/ntpeters/vim-better-whitespace'
  let g:better_whitespace_ctermcolor='red'
  let g:strip_whitespace_on_save=1


" vim-peekaboo:  " / @ / C-r
  Plug 'https://github.com/junegunn/vim-peekaboo'
  source $HOME/dotfiles/files/nvim/plugins/peekaboo.vim


" vim-easy-align
  Plug 'https://github.com/junegunn/vim-easy-align'
  " align backslashes in e.g. multi-line bash, C macros etc.:
  let g:easy_align_delimiters={
    \ '\': {'pattern': '\\$'}
  \ }


" git and other VCS

  " fugitive
  Plug 'https://github.com/tpope/vim-fugitive'
  source $HOME/dotfiles/files/nvim/plugins/fugitive.vim

  nnoremap <silent><leader>gb :Git blame<CR>


  " fugitive `:GBrowse` plugins
  Plug 'https://github.com/tpope/vim-rhubarb'

  Plug 'https://github.com/shumphrey/fugitive-gitlab.vim'
  let s:gitlab_work_domain=v:lua.mmy_GetLocalConfigVariable('GITLAB_WORK_DOMAIN')
  let g:fugitive_gitlab_domains=['https://gitlab.com', s:gitlab_work_domain]


" vim-polyglot (syntax highlighting)
" TODO: move to treesitter?
  Plug 'https://github.com/sheerun/vim-polyglot'

" ansible
  Plug 'https://github.com/pearofducks/ansible-vim', { 'do': './UltiSnips/generate.sh' }
  " for coc-ansible
  let g:coc_filetype_map = {
    \ 'yaml.ansible': 'ansible',
    \ }


" ale (syntax checker)
" it's still useful for some checks, e.g. shellcheck for bash/zsh TODO is it?
" Command :ALEInfo to print the runtime information for the current buffer
  Plug 'https://github.com/dense-analysis/ale'
  " === python ===
  let g:ale_python_flake8_options=''
  let g:ale_python_pylint_executable=''


" highlight visual selections
  Plug 'https://github.com/kdav5758/HighStr.nvim'
  nnoremap <silent> <f1> :HSRmHighlight<CR>
  vnoremap <silent> <f1> :<c-u>HSRmHighlight<CR>
  vnoremap <silent> <f2> :<c-u>HSHighlight 1<CR>
  vnoremap <silent> <f3> :<c-u>HSHighlight 7<CR>
  vnoremap <silent> <f4> :<c-u>HSHighlight 3<CR>


" Colors
  Plug 'https://github.com/romainl/Apprentice'
  Plug 'https://github.com/chriskempson/base16-vim'


" --- Candidate plugins ----
" A plugin is a candidate first, and if it's useful, it's promoted to the up.

call plug#end()


" ----- Colors -------------------------------------------------------------

" General colorscheme
  colorscheme apprentice
  set background=dark

" terminal stuff
  source $HOME/dotfiles/files/nvim/vim/terminal.vim

" Highlight groups
"
" Debug tips:
"   - `verbose hi <Name>` shows where the hi group is set.
"   - Run `:so $VIMRUNTIME/syntax/hitest.vim` to see all highlight groups.
  highlight Todo guibg=#800000 guifg=#d0d090 gui=italic
  highlight Comment gui=italic
  " the vertical split color:
  highlight VertSplit guibg=NONE
  highlight SignColumn guibg=#1c1c1c
  highlight ColorColumn guibg=#1c1c1c
  highlight CursorLine guibg=#1c1c1c

  function! s:quickfix_win()
    highlight QuickFixLine gui=bold guifg=Black guibg=DarkGray
    setlocal signcolumn=no
    setlocal colorcolumn=
  endfunction

  function! s:fzf_win()
    setlocal winhighlight=Normal:Pmenu
  endfunction

  function! s:nerdtree_win()
    highlight NERDTreeFile guifg=LightGray
    highlight NERDTreeExecFile gui=bold guifg=White
    setlocal winhighlight=Normal:SignColumn
  endfunction

  function! s:tagbar_win()
    setlocal winhighlight=Normal:SignColumn
  endfunction

  augroup HiglightTypes
    autocmd BufWinEnter quickfix call s:quickfix_win()
    autocmd FileType fzf call s:fzf_win()
    autocmd FileType nerdtree call s:nerdtree_win()
    autocmd FileType tagbar call s:tagbar_win()
  augroup END


" #### THE END ####
