#!/usr/bin/env bash

source 'helpers.sh'

main() {
  echo "RoadHouse Bootstrap Script"
  export CODE_DIR="$HOME/code/"

  install_git
  create_code_dir
  cd "$CODE_DIR" || exit
  download_dotfiles
  cd "dotfiles" || exit
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
