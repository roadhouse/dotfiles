#!/usr/bin/env bash

install_group() {
  local group_file_name="$1.pkgs.txt"
  if [ -f $group_file_name ]; then
    info_message "installing pkgs in $group_file_name"
    xargs -a $group_file_name sudo apt-get install --quiet
  else
    error_message "$group_file_name not found"
  fi
}

create_symlinks() {
  for i in $(ls files); do
    ln -s $PWD/files/$i ~/.$i;
  done
}

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

info_message() {
  say "@b@blue[[INFO]]: $@"
}

error_message() {
  say "@b@red[[ERROR]]: $@"
}
