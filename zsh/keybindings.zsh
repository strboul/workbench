# SC2148: Don't ask for a shebang for this file, which is not supported.
# shellcheck disable=SC2148

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
  if git status >/dev/null ; then
    BUFFER="git status"
  else
    if git-substatus >/dev/null ; then
      BUFFER="git-substatus"
    fi
  fi
  zle accept-line
}
zle -N __zle_widget__git_status
bindkey "^s" __zle_widget__git_status


# Add all git-tracked & commit & push
__zle_widget__git_add_commit_push() {
  if [ -n "$BUFFER" ]; then
    BUFFER="git add -u; git commit -m \"$BUFFER\" && git push"
  elif [ -z "$BUFFER" ]; then
    BUFFER="git add -u; git commit && git push"
  fi
  zle accept-line
}
zle -N __zle_widget__git_add_commit_push
bindkey "^g" __zle_widget__git_add_commit_push


# Enable Ctrl-x-e to edit long commands with the $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
