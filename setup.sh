#!/usr/bin/env bash

source "$HOME"/dotfiles/zsh/utils.sh

set -e

# --------------------------------------------------------------------------- #
# check ----
# --------------------------------------------------------------------------- #

check__dotfiles_in_home_dir() {
  if [[ ! -d "$HOME"/dotfiles ]]; then
    utils__err_exit "dotfiles/ not found in the home directory. Aborted."
  fi
}


check__pkg_managers_installed() {
  echo "Checking OS package manager availability"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ -x "$(command -v brew)" ]; then
      utils__color_msg "green" "brew found."
    else
      utils__err_exit "brew not found. Install brew \"https://brew.sh\""
    fi
  elif [[ "$OSTYPE" == "linux"* ]]; then
    if [ -x "$(command -v apt-get)" ]; then
      utils__color_msg "green" "apt found."
    else
      utils__err_exit "apt not found in the system."
    fi
  else
    utils__err_exit "platform not supported."
  fi
}


check__curl_installed() {
  if [ ! -x "$(command -v curl)" ]; then
    echo "curl not found. Install cURL first."
    utils__err_exit "Aborted."
  fi
}


# --------------------------------------------------------------------------- #
# install ----
# --------------------------------------------------------------------------- #

# Asks first and then installs by using (available) package managers
install__ask_install_with_pkg_manager() {
  echo "Checking to see whether [$1|$2] is installed"
  if [ ! -x "$(command -v "$1")" ]; then
    utils__user_prompt "\"$1\" not found. Would you like to install it?" >&2
    install__install_with_pkg_manager "$2"
  else
    echo "$1 : $2 is installed. Skipping."
  fi
}


# Installs with the built-in package manager
install__install_with_pkg_manager() {
  if [ -x "$(command -v apt-get)" ]; then
    sudo apt-get install "$1" -y
  elif [ -x "$(command -v brew)" ]; then
    brew install "$1"
  else
    echo "platform/pkg manager not supported."
  fi
}


### Programs to install ###

# https://github.com/junegunn/fzf
install__fzf() {
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install
}


# https://github.com/BurntSushi/ripgrep
install__ripgrep() {
  # TODO fix the do_install_with_pkg_manager function definition file
  install__install_with_pkg_manager ripgrep
}


# https://github.com/sharkdp/fd
install__fd() {
  # FIXME
  install__install_with_pkg_manager fd
}


install__python() {
  # TODO make it work
  source "$HOME"/dotfiles/install/python.sh
}


install__nodejs() {
 # FIXME
  install__install_with_pkg_manager nodejs
}


# https://github.com/universal-ctags/ctags.git
install__universal_ctags() {
  git clone https://github.com/universal-ctags/ctags.git /tmp/ctags && \
    pushd /tmp/ctags &&               \
    ./autogen.sh &&                   \
    ./configure --program-prefix=u && \
    make && make install &&           \
    popd &&                           \
    rm -rf /tmp/ctags/
}


# https://github.com/tpope/vim-sensible
install__vim_sensible() {
  if [ ! -f "$HOME"/.vimrc ]; then
    wget -O \
    "$HOME"/.vimrc \
    https://raw.githubusercontent.com/tpope/vim-sensible/master/plugin/sensible.vim
  fi
}


install__htop() {
  install__install_with_pkg_manager htop htop
}


# https://github.com/strboul/git-substatus
install__git_substatus() {
  # FIXME move it to install/python with pip (when applicable)
  curl -L \
    https://raw.githubusercontent.com/strboul/git-substatus/master/git-substatus.py \
    > "$HOME"/bin/git-substatus && \
    chmod u+x "$HOME"/bin/git-substatus
}


install__shellcheck() {
  # https://github.com/koalaman/shellcheck
  install__install_with_pkg_manager shellcheck shellcheck
}


# --------------------------------------------------------------------------- #
# shell ----
# --------------------------------------------------------------------------- #

# Change the default shell to zsh.
shell__change_default_shell() {
  if [ -z "${SHELL##*zsh*}" ]; then
    echo "Default shell is zsh."
  else
    utils__user_prompt "
    Default shell is not \"zsh\".
    Do you want to \`chsh -s $(command -v zsh)\`?
    (Tip: leave the password prompt empty by pressing the <Enter> right away.)
    "
    chsh -s "$(command -v zsh)"
    echo "Success! Shell should be changed upon the next login."
  fi
}


shell__check_default_shell() {
  {
    shell__change_default_shell
  } || {
    utils__color_msg "red"                                                \
    "The configuration will not work properly without \"zsh\"."    \
    "\nTroubleshooting:"                                           \
    "If you received \"chsh: PAM: Authentication failure\" error," \
    "you can try to do the following actions:"                     \
    "Open file \`sudo vi /etc/pam.d/chsh\`"                        \
    "\`auth       required   pam_shells.so\` should be:"           \
    "\`auth       sufficient   pam_shells.so\`"
    utils__err_exit "Aborted."
  }
}

# --------------------------------------------------------------------------- #
# main ----
# --------------------------------------------------------------------------- #

main() {

  # main variables:
  num_dashes_to_print=79

  utils__print_dashes $num_dashes_to_print

  echo
  echo "Pulling latest changes from the remote..."
  (cd ~/dotfiles && git pull && git submodule update --init --recursive)
  echo

  # Pre-installation checks
  check__dotfiles_in_home_dir
  check__curl_installed
  check__pkg_managers_installed
  echo

  # Prompting user first time
  echo "Configure and install the dotfiles"
  echo "Installing: zsh, neovim, tmux"
  utils__user_prompt "Let's get started?"
  echo

  install__install_with_pkg_manager "zsh" "zsh"
  echo

  # FIXME neovim and tmux have outdated versions in apt-get
  install__install_with_pkg_manager "nvim" "neovim"
  echo

  install__install_with_pkg_manager "tmux" "tmux"
  echo


  # Link all files:
  source "$HOME"/dotfiles/zsh/link.sh
  echo


  # program installs:
  install__fzf
  install__ripgrep
  install__fd
  install__python
  install__nodejs
  install__universal_ctags
  install__vim_sensible
  install__htop
  install__git_substatus
  install__shellcheck


  shell__check_default_shell
  echo


  echo "Please log out and log back in for default shell to be initialized."

  utils__print_dashes $num_dashes_to_print
}

main
