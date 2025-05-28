#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update -qq
sudo apt-get install -yqq software-properties-common git python3 python3-pip

sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install -yqq ansible

CODE_DIR="$HOME/code"
mkdir -p "$CODE_DIR"

if [ ! -d "$CODE_DIR/dotfiles" ]; then
  git clone --depth 1 https://github.com/roadhouse/dotfiles.git "$CODE_DIR/dotfiles"
fi

cd "$CODE_DIR/dotfiles"
ansible-playbook -i inventory playbooks/site.yml --ask-become-pass
