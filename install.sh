#!/usr/bin/env bash

source "helpers.sh"

main() {
  install_group "base"
  create_symlinks
}

#running script
main
