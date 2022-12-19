#!/usr/bin/env bash

export CODE_DIR="$HOME/code/"

#from here: https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
say() {
  echo "$@" | sed \
    -e "s/\(\(@\(red\|green\|yellow\|blue\|magenta\|cyan\|white\|reset\|b\|u\)\)\+\)[[]\{2\}\(.*\)[]]\{2\}/\1\4@reset/g" \
    -e "s/@red/$(tput setaf 1)/g" \
    -e "s/@green/$(tput setaf 2)/g" \
    -e "s/@yellow/$(tput setaf 3)/g" \
    -e "s/@blue/$(tput setaf 4)/g" \
    -e "s/@magenta/$(tput setaf 5)/g" \
    -e "s/@cyan/$(tput setaf 6)/g" \
    -e "s/@white/$(tput setaf 7)/g" \
    -e "s/@reset/$(tput sgr0)/g" \
    -e "s/@b/$(tput bold)/g" \
    -e "s/@u/$(tput sgr 0 1)/g"
}
info_message() { say "@b@blue[[[INFO]]]: $@"; }
error_message() { say "@b@red[[[ERROR]]]: $@"; }
success_message() { say "@b@green[[[SUCESS]]]: $@"; }

install_git() {
  #verify if git is a executable and is in the path, otherwise install
  [ ! -x "$(command -v git)" ] && sudo apt-get -y install git || success_message "git installed"
}

create_code_dir() {
  if [ ! -d $CODE_DIR ]; then
    info_message "creating code dir"
    mkdir $CODE_DIR
  else
    error_message "code dir already exists"
  fi
}

download_dotfiles() {
  local repo_dir=$CODE_DIR"dotfiles"
  if [ ! -d $repo_dir ]; then
    git clone https://github.com/roadhouse/dotfiles.git
  else
    error_message "dotfiles dir already exists"
  fi
}

install_group() {
  local os=""
  if [[ "$1" != "base" ]]; then
    local os=$(lsb_release -is|tr '[:upper:]' '[:lower:]').
  fi
  # local group_file_name="$os$1.pkgs.txt"
  # echo $group_file_name

  if [ -f $group_file_name ]; then
    info_message "installing pkgs in $group_file_name"
    xargs -a $group_file_name sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install
  else
    error_message "$group_file_name not found"
  fi
}

create_symlinks() {
  for i in $(ls files); do
    ln -s $PWD/files/$i ~/.$i;
  done
}

change_shell_to_zsh() {
  [ -x "$(command -v zsh)" ] && chsh -s $(command -v zsh)
}

enable_tap_on_touchpad() {
  local repo_dir=$CODE_DIR"dotfiles"
  sudo cp $repo_dir/files/touchpad-tap.conf /etc/X11/xorg.conf.d

  info_message "tap on trackpad enable (restart X required)"
}
