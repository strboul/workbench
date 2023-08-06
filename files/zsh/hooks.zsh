# zsh hooks
#

# always ls after cd into folders
__cdls() {
  emulate -L zsh
  myls
}
add-zsh-hook chpwd __cdls

# git-crypt status
__git_crypt_status() {
  if [[ -d .git-crypt ]]; then
    git-crypt-status
  fi
}
add-zsh-hook chpwd __git_crypt_status
