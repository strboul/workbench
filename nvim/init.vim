:scriptencoding utf-8

source $HOME/dotfiles/nvim/mmy.vim

" ----- General settings ---------------------------------------------------

  source $HOME/dotfiles/nvim/essential.vim

" Window display
  set nonumber         " line numbers
  set norelativenumber " relative line numbers
  set cursorline       " horizontal cursor bar for the current line
  set laststatus=2     " always show the status bar
  set showtabline=2    " always show the tab bar
  set noshowmode       " no showmode e.g. --INSERT-- display, check statusbar
  set splitright       " always open h-splits at the right side
  set splitbelow       " always open v-splits at the below side
  set scrolloff=1      " off the lines when scrolling down
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
  set expandtab                  " always add spaces when tab
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
  set timeout timeoutlen=500 ttimeout ttimeoutlen=10


" Default (4000 ms ~ 4 s) is too slow. And a very low value can slow down vim.
  set updatetime=100


" darken the screen after the 80th char
  let &colorcolumn='80,'.join(range(80,999),',')


" stop continuing comments (see `:help formatoptions` and `:help fo-table`)
" FIXME doesn't work, it's a bug in vim
  " autocmd FileType * setlocal formatoptions-=cro


" essential autocommands
  source $HOME/dotfiles/nvim/autocmds.vim

" Quickfix
  source $HOME/dotfiles/nvim/quickfix.vim

" Help
  source $HOME/dotfiles/nvim/help.vim

  source $HOME/dotfiles/nvim/filetypes.vim
  source $HOME/dotfiles/nvim/mappings.vim

" ----- Plugins ------------------------------------------------------------

" Auto installation vim-plug (https://github.com/junegunn/vim-plug)
  augroup VimPlugInstall
    if empty(glob($XDG_DATA_HOME . '/nvim/site/autoload/plug.vim'))
      silent !curl -fLo $XDG_DATA_HOME . '/nvim/site/autoload/plug.vim' --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
  augroup END


" Specify directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Debug: - check the running paths with `:set runtimepath?`
" - Use full URL because it's easy to go to the link with `gx`
call plug#begin(stdpath('config') . '/vim-plug')

" fzf
  Plug 'https://github.com/junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'https://github.com/junegunn/fzf.vim'
  source $HOME/dotfiles/nvim/plugins/fzf.vim


" lightline
  Plug 'itchyny/lightline.vim'
  source $HOME/dotfiles/nvim/plugins/lightline.vim


" NERDTree
  Plug 'https://github.com/preservim/nerdtree'
  source $HOME/dotfiles/nvim/plugins/nerdtree.vim


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
  source $HOME/dotfiles/nvim/plugins/coc/coc.vim


" tagbar
  Plug 'https://github.com/preservim/tagbar'
  " tags should be sorted by order of their apperance, not alphabetically
  let g:tagbar_sort=0


" Vista
  Plug 'https://github.com/liuchengxu/vista.vim'


" urlview
  Plug 'https://github.com/strboul/urlview.vim' " :Urlview


" any-jump
  Plug 'https://github.com/pechorin/any-jump.vim' " <leader>j


" UltiSnips
" TODO look for alternatives, as it's slow.
  Plug 'https://github.com/sirver/UltiSnips'
  " don't use any expand key (because using `coc-snippets` for)
  let g:UltiSnipsExpandTrigger='<nop>'


" floaterm
  Plug 'voldikss/vim-floaterm'

  function! s:floaterm_lazygit()
    :FloatermNew lazygit
  endfunction
  command Lg :call s:floaterm_lazygit()

  source $HOME/dotfiles/nvim/plugins/floaterm.vim


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
  source $HOME/dotfiles/nvim/plugins/peekaboo.vim


" vim-easy-align
  Plug 'https://github.com/junegunn/vim-easy-align'
  " align backslashes in e.g. multi-line bash, C macros etc.:
  let g:easy_align_delimiters={
    \ '\': {'pattern': '\\$'}
  \ }


" git and other VCS

  " fugitive
  Plug 'https://github.com/tpope/vim-fugitive'
  augroup FugitiveBlameWin
    " - ESC closes the window
    autocmd FileType fugitiveblame nnoremap <buffer><silent> <ESC> :q<CR>
  augroup END


  " rhubarb for GitHub (for `:Gbrowse` mainly)
  Plug 'https://github.com/tpope/vim-rhubarb'


" vim-polyglot (syntax highlighting)
  Plug 'https://github.com/sheerun/vim-polyglot'


" prisma2 syntax highlighting
  Plug 'https://github.com/pantharshit00/vim-prisma'


" ale (syntax checker)
" it's still useful for some checks, e.g. shellcheck for bash/zsh TODO is it?
  Plug 'https://github.com/dense-analysis/ale'
  " disable linting on some files
  " https://github.com/dense-analysis/ale/issues/371#issuecomment-304313091
  let g:ale_pattern_options={
    \ '.R$':   {'ale_enabled': 0},
    \ '.Rmd$': {'ale_enabled': 0},
    \ '.py$':  {'ale_enabled': 0},
    \ '.js$':  {'ale_enabled': 0},
    \ '.jsx$':  {'ale_enabled': 0},
    \ '.ts$':  {'ale_enabled': 0},
    \ '.tsx$':  {'ale_enabled': 0},
    \ '.json.*$':  {'ale_enabled': 0}
  \}


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

" Plug 'https://github.com/Einenlum/yaml-revealer'

call plug#end()


" ----- Colors -------------------------------------------------------------

" General colorscheme
  colorscheme apprentice
  set background=dark

" terminal stuff
  source $HOME/dotfiles/nvim/terminal.vim

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
