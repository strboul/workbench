#!/usr/bin/env bash

# Symbolic link the files (config, tools etc.) so that they are always git
# controlled.

source "$HOME"/dotfiles/zsh/utils.sh

set -e

do_link() {
  # TODO replace $1 $2 with source destination
  utils__check_file_or_dir_exists \
    "$1" \
    "$(printf "file or folder not exist in dotfiles: \"%s\"" "$1")"
  mkdir -p "${2%/*}"
  if [[ -h "$2" ]]; then
    printf "symlink already exists in: \"%s\" -> \"%s\"\n" "$1" "$2"
  else
    utils__log__success "$(printf "Linking: \"%s\" -> \"%s\"\n" "$1" "$2")"
    ln -sfn "$1" "$2"
  fi
}

stop_if_broken_symlinks() {
  get_broken_symlinks() {
    path="$1"
    "/bin/find" "$path" -maxdepth 1 -xtype l
  }
  symlinks="$(get_broken_symlinks "$HOME")"
  symlinks_len="$(echo "$symlinks" | wc -l)"
  if [ "$symlinks_len" -gt 1 ]; then
    utils__log__error "there \"$symlinks_len\" broken symlinks in path: \"$HOME\""
    echo -ne "\n$symlinks\n\n"
    utils__err_exit "clean them up to proceed."
  fi
}

stop_if_broken_symlinks

# zsh
do_link "$HOME"/dotfiles/zsh/zshrc.zsh "$HOME"/.zshrc

# tmux
do_link "$HOME"/dotfiles/tmux/tmux.conf "$HOME"/.tmux.conf

# nvim
do_link "$HOME"/dotfiles/nvim/init.vim "$XDG_CONFIG_HOME"/nvim/init.vim
do_link "$HOME"/dotfiles/nvim/plugins/coc/coc-settings.json "$XDG_CONFIG_HOME"/nvim/coc-settings.json
do_link "$HOME"/dotfiles/nvim/snippets/ "$XDG_CONFIG_HOME"/nvim/UltiSnips
# nvim2
# lua config is accessible via v2 alias defined in zshrc
do_link "$HOME"/dotfiles/nvim/lua "$XDG_CONFIG_HOME"/nvim2/lua

# lang
do_link "$HOME"/dotfiles/lang/R/Rprofile.R "$HOME"/.Rprofile
do_link "$HOME"/dotfiles/lang/python/pythonstartup.py "$HOME"/.pythonstartup

# tools/alacritty
do_link "$HOME"/dotfiles/tools/alacritty/alacritty.yml "$XDG_CONFIG_HOME"/alacritty/alacritty.yml
# tools/rg
do_link "$HOME"/dotfiles/tools/rg/ripgreprc "$HOME"/.ripgreprc
do_link "$HOME"/dotfiles/tools/rg/rgignore "$HOME"/.rgignore
# tools/bat
do_link "$HOME"/dotfiles/tools/bat/batconf "$HOME"/.batconf
# tools/git
do_link "$HOME"/dotfiles/tools/git/gitconfig "$HOME"/.gitconfig
do_link "$HOME"/dotfiles/tools/git/gitignore_global "$HOME"/.gitignore
# tools/lazygit
do_link "$HOME"/dotfiles/tools/lazygit/config.yml "$XDG_CONFIG_HOME"/lazygit/config.yml
# tools/shellcheck
do_link "$HOME"/dotfiles/tools/shellcheck/shellcheckrc "$HOME"/.shellcheckrc
# tools/fonts
do_link "$HOME"/dotfiles/tools/fonts/JetBrainsMono/ "$HOME"/.local/share/fonts

# editors
do_link "$HOME"/dotfiles/editors/rstudio/r_rstudio.snippets "$HOME"/.R/snippets/r.snippets
