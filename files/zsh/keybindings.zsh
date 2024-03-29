# zsh keybindings
#
# Get the bindkey of a combination.
#   bindkey '^r'
#

# list files via ll (alias defined in zshrc)
__zle_widget__list_files() {
  BUFFER="ll"
  zle accept-line
}
zle -N __zle_widget__list_files
bindkey "^[l" __zle_widget__list_files

# git status
#
# If 'git status' command doesn't work (i.e. returning a status code of 128),
# call 'git-substatus' (https://github.com/strboul/git-substatus) instead.
__zle_widget__git_status() {
  if git status > /dev/null; then
    BUFFER="git status"
  else
    if git-substatus > /dev/null; then
      BUFFER="git-substatus"
    fi
  fi
  zle accept-line
}
zle -N __zle_widget__git_status
bindkey "^s" __zle_widget__git_status

# Enable Ctrl-x-e to edit long commands with the $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

# c-k/j to shuffle in zsh history
bindkey '^k' up-line-or-history
bindkey '^j' down-line-or-history
