#!/usr/bin/env bash

source 'helpers.sh'

main() {
  echo "RoadHouse Bootstrap Script"
  export CODE_DIR="$HOME/code/"

  install_git
  create_code_dir
  cd $CODE_DIR
  download_dotfiles
  cd "dotfiles"
  install_group "base"
  create_symlinks
  change_shell_to_zsh
  enable_tap_on_touchpad
}

#running setup
main
