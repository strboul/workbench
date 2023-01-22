# disable the update prompt from oh-my-zsh, just update.
export DISABLE_UPDATE_PROMPT=true

# set locales
export LANG="en_US.UTF-8"
# time is British (start week from Monday)
export LC_TIME="en_GB.UTF-8"
# paper is British (A4 etc.)
export LC_PAPER="en_GB.UTF-8"

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
# plugins: git related
plugins+=(
  git-auto-fetch
)
# plugins: others (autocomplete & tooling)
plugins+=(
  aws
  direnv
  docker
  docker-compose
  helm
  kubectl
  npm
  nvm
  pass
  terraform
  yarn
)

source "$ZSH"/oh-my-zsh.sh

# ===== paths =====

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/dotfiles/bin:$PATH"

# ===== sources =====

# zsh keybindings
source "$HOME"/dotfiles/files/zsh/keybindings.zsh
source "$HOME"/dotfiles/files/zsh/navi_keybindings.zsh

# for gnupg
GPG_TTY="$(tty)"
export GPG_TTY

# ===== settings =====

export EDITOR="nvim -u DEFAULTS"
export DISABLE_AUTO_TITLE="true"

# don't change dir without 'cd' command
unsetopt AUTO_CD
# don't use `less` pager for some commands, e.g. git
unset LESS

# History settings
# save commands to history on type, not at shell exit
setopt INC_APPEND_HISTORY
# append command to history file immediately after execution
setopt INC_APPEND_HISTORY_TIME
# share history across zsh sessions
setopt SHARE_HISTORY
# ignore all duplicate entries in the zsh history
setopt HIST_IGNORE_ALL_DUPS
# do not save duplicated commands
setopt HIST_SAVE_NO_DUPS
# remove unnecessary whitespace
setopt HIST_REDUCE_BLANKS
# don't save commands starting with a space in history
setopt HIST_IGNORE_SPACE
# record command starttime
setopt EXTENDED_HISTORY
# don't write these commands as is to the history.
export HISTORY_IGNORE="(history|ls|cd|cd ..|pwd|clear|exit|cd)"

# ===== aliases =====

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

alias v='mynvim'
# python and bpython using different PYTHONPATH (https://stackoverflow.com/a/22182421)
bpython() {
  if test -n "$VIRTUAL_ENV"; then
    PYTHONPATH="$(python -c 'import sys; print(":".join(sys.path))')" \
      command bpython "$@"
  else
    command bpython "$@"
  fi
}
alias py='command -v bpython &> /dev/null && eval $(command -v bpython) || python'
# it's annoying to have __pycache__ files laying around.
export PYTHONDONTWRITEBYTECODE=1

# https://github.com/jesseduffield/lazygit
export LG_CONFIG_FILE="$XDG_CONFIG_HOME/lazygit/config.yml"

# ===== autocomplete =====

# makefile
zstyle ":completion:*:*:make:*" tag-order "targets"

# ===== hooks =====
# always ls after cd into folders
__cdls() {
  emulate -L zsh
  ls
}
add-zsh-hook chpwd __cdls

# ===== configs =====

# https://github.com/BurntSushi/ripgrep/blob/0.8.0/GUIDE.md#configuration-file
export RIPGREP_CONFIG_PATH="$HOME"/.ripgreprc
# https://github.com/sharkdp/bat#configuration-file
export BAT_CONFIG_PATH="$HOME"/.batconf
export PYTHONSTARTUP=$HOME/.pythonstartup

# fzf (https://github.com/junegunn/fzf)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--no-separator"
# use 'fd' (https://github.com/sharkdp/fd) in fzf to ignore git files.
# (Source: https://github.com/junegunn/dotfiles/blob/ba5013726515e5185a2840b4b133991fe37b8827/bashrc#L369-L373)
if command -v fd > /dev/null; then
  __fd_custom="$(command -v fd) --hidden --follow --exclude .git"
  export FZF_DEFAULT_COMMAND="$__fd_custom --type f"
  export FZF_ALT_C_COMMAND="$__fd_custom --type d"
  export FZF_CTRL_T_COMMAND="$__fd_custom --type f --type d"
fi

# p10k (https://github.com/romkatv/powerlevel10k)
# To customize prompt, run `p10k configure` or edit ~/dotfiles/files/p10k/p10k.zsh.
[[ ! -f ~/dotfiles/files/p10k/p10k.zsh ]] || source ~/dotfiles/files/p10k/p10k.zsh
