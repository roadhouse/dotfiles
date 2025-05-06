#!/usr/bin/env bash
# Simple bootstrap script to install Ansible + requirements on Ubuntu/Debian
# Usage:
#   curl -s https://raw.githubusercontent.com/roadhouse/dotfiles/master/ansible/bootstrap-ansible.sh | bash
set -euo pipefail

# Update cache and install prerequisites
sudo apt-get update -qq
sudo apt-get install -yqq software-properties-common python3 python3-pip

# Add Ansible PPA (latest stable)
sudo add-apt-repository --yes --update ppa:ansible/ansible

# Install Ansible
sudo apt-get install -yqq ansible

# Verify
ansible --version | head -n 1

echo "\n[+] Ansible installed successfully. You can now run the playbook:" >&2
echo "   cd ansible && ansible-playbook -i inventory playbooks/site.yml --ask-become-pass" >&2
