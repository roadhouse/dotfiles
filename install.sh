#!/usr/bin/env bash

install_git() {
  #verify if git is a executable and is in the path, otherwise install
  [ ! -x "$(command -v git)" ] && sudo apt-get -y install git || echo "git installed"
}

create_code_dir() {
  if [ ! -d "$CODE_DIR" ]; then
    echo "creating code dir"
    mkdir "$CODE_DIR"
  else
    echo "code dir already exists"
  fi
}

download_dotfiles() {
  local repo_dir=$CODE_DIR"dotfiles"
  if [ ! -d "$repo_dir" ]; then
    git clone --depth 1 https://github.com/roadhouse/dotfiles.git
  else
    echo "dotfiles dir already exists"
  fi
}

main() {
  echo "RoadHouse Bootstrap Script"

  export CODE_DIR="$HOME/code/"

  sudo apt-get update

  install_git
  create_code_dir
  cd "$CODE_DIR" || exit
  download_dotfiles
  cd "dotfiles" || exit
  source 'helpers.sh'
  install_group "base"
  create_symlinks
  change_shell_to_zsh
  download_zsnap
  enable_tap_on_touchpad
  install_monoid_patched_font
  install_nvim_from_github

  echo "Finished system configuration"
}

#running setup
main
