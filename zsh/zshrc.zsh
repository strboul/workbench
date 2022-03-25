# disable the update prompt from oh-my-zsh, just update.
export DISABLE_UPDATE_PROMPT=true

# set lang locale to US utf-8
export LANG="en_US.UTF-8"
# set date/time locale to US utf-8
export LC_TIME="en_US.UTF-8"

# XDG base (https://wiki.archlinux.org/title/XDG_Base_Directory)
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# ===== tmux =====

# Initialize tmux on zsh start-up if
# (1) tmux exists,
# (2) terminal emulator is alacritty.
if command -v tmux > /dev/null; then
  [ -z "$TMUX" ] \
    && [ "$TERM_PROGRAM" = "alacritty" ] \
    &&
    # -u   is for UTF-8
    # -2   force tmux to assume the terminal supports 256 colours.
    exec tmux -2 -u
fi

# change the default term to TMUX that it can display 256 colors
export TERM=xterm-256color

# ===== oh-my-zsh =====

export ZSH="$HOME/.oh-my-zsh"

export ZSH_THEME="powerlevel10k/powerlevel10k"

# See all available plugins: https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
#
# plugins: zsh related
plugins+=(
  history-substring-search
  z
  zsh-autosuggestions
  zsh-syntax-highlighting
)
# plugins: others (autocomplete & tooling)
plugins+=(
  aws
  docker
  docker-compose
  direnv
  helm
  kubectl
  npm
  nvm
  terraform
  yarn
)

source "$ZSH"/oh-my-zsh.sh

# ===== autocomplete =====

# makefile
zstyle ":completion:*:*:make:*" tag-order "targets"

# ===== paths =====

export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/dotfiles/bin:$PATH"

# ===== sources =====

source "$HOME"/dotfiles/zsh/keybindings.zsh

# ===== settings =====

export EDITOR="nvim -u DEFAULTS"
export DISABLE_AUTO_TITLE="true"

# don't change dir without 'cd' command
unsetopt AUTO_CD
# don't use `less` pager for some commands, e.g. git
unset LESS
# save commands to history on type, not at shell exit
setopt INC_APPEND_HISTORY
# share history across zsh sessions
setopt SHARE_HISTORY
# ignore all duplicate entries in the zsh history
setopt HIST_IGNORE_ALL_DUPS
# do not save duplicated command
setopt HIST_SAVE_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
# don't save commands starting with a space in history
setopt HIST_IGNORE_SPACE
# append command to history file immediately after execution
setopt INC_APPEND_HISTORY_TIME
setopt EXTENDED_HISTORY

# don't write these commands to the history
# TODO test this, <c-r> or history doesn't work but cat ~/.zsh_history works
export HISTORY_IGNORE="(history|ls|cd|cd ..|pwd|clear|exit|cd|v)"

# ===== aliases =====

__cdls() {
  # Custom cd (always ls when cd into a folder)
  builtin cd "$@" && ls
}
alias cd="__cdls"

__cdr() {
  # jump to the root path of a git repository
  cd "$(git rev-parse --show-toplevel)" || exit
}
alias cdr="__cdr"

alias cp='cp -iv' # 'cp' prompt and verbose
alias mv='mv -iv' # 'mv' prompt and verbose

# - `-F`: appends indicator (`/` for folders, `*` for executables)
# - `-v`: natural sorts
# - `-h`: gives human readable file sizes
# - `--group-directories-first`: puts directories first
alias ls='ls -Fv --color=auto --group-directories-first'
alias ll='ls -lh'
alias la='ll -a'

alias v='eval $(command -v nvim)'

# https://github.com/randy3k/radian
alias r='eval $(command -v radian)'
# https://github.com/bpython/bpython
alias py='eval $(command -v bpython)'

# https://github.com/jesseduffield/lazygit
export LG_CONFIG_FILE="$XDG_CONFIG_HOME/lazygit/config.yml"
alias lg='tmux-zoom lazygit'

# ===== prompt =====
# run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ===== configs =====

# TODO: all path manipulations go to .zprofile with workbench.
export PATH=$PATH:/usr/local/go/bin
# $GOPATH env variable
gopath="$(go env GOPATH)"
export PATH=$PATH:"$gopath"/bin

# direnv: don't print the variable list
export DIRENV_LOG_FORMAT=

# https://github.com/BurntSushi/ripgrep/blob/0.8.0/GUIDE.md#configuration-file
export RIPGREP_CONFIG_PATH="$HOME"/.ripgreprc
# https://github.com/sharkdp/bat#configuration-file
export BAT_CONFIG_PATH="$HOME"/.batconf
export PYTHONSTARTUP=$HOME/.pythonstartup

# pyenv (https://github.com/pyenv/pyenv)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv > /dev/null; then
  eval "$(pyenv init -)"
fi
eval "$(pyenv init --path)"

# fzf (https://github.com/junegunn/fzf)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# use 'fd' (https://github.com/sharkdp/fd) in fzf to ignore git files.
# (Source: https://github.com/junegunn/dotfiles/blob/ba5013726515e5185a2840b4b133991fe37b8827/bashrc#L369-L373)
if command -v fd > /dev/null; then
  __fd_custom="$(command -v fd) --strip-cwd-prefix --hidden --follow --exclude .git"
  export FZF_DEFAULT_COMMAND="$__fd_custom --type f"
  export FZF_ALT_C_COMMAND="$__fd_custom --type d"
  export FZF_CTRL_T_COMMAND="$__fd_custom --type f --type d"
fi
