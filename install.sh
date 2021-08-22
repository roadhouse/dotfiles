#!/usr/bin/env bash

install_git() {
  #verify if git is a executable and is in the path
  [ ! -x "$(command -v git)" ] && sudo apt-get install git || echo "git installed"
}


create_code_dir() {
  if [ ! -d $CODE_DIR ]; then
    echo "creating code dir"
    mkdir $CODE_DIR
  else
    echo "code dir already exists"
  fi
}

download_dotfiles() {
  local repo_dir=$CODE_DIR"dotfiles"
  if [ ! -d $repo_dir ]; then
    git clone https://github.com/roadhouse/dotfiles.git
  else
    echo "dotfiles dir already exists"
  fi
}

main() {
  echo "RoadHouse Bootstrap Script"
  export CODE_DIR="$HOME/code/"

  install_git
  create_code_dir
  cd $CODE_DIR
  download_dotfiles
  cd "dotfiles"
  source "helpers.sh"
  install_group "base"
  create_symlinks
}

#running setup
main
