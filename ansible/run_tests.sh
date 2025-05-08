#!/bin/bash

# Simplified Ansible Test Runner
# Author: RoadHouse
# Date: 2025-05-07

set -e

# Change to the ansible directory
cd "$(dirname "$0")"

# Colors for output
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

echo -e "${BLUE}=== Running Ansible Tests ===${NC}\n"

# Function to run a test and report status
run_test() {
  local test_name=$1
  local test_command=$2
  local test_args="${3:--v}"  # Default to verbose mode

  echo -e "${YELLOW}Running $test_name...${NC}"
  if eval "$test_command $test_args"; then
    echo -e "${GREEN}✓ $test_name passed${NC}\n"
    return 0
  else
    echo -e "${RED}✗ $test_name failed${NC}\n"
    return 1
  fi
}

# Check for dependencies and run linting if available
if command -v yamllint &> /dev/null; then
  run_test "YAML Linting" "yamllint ." ""
else
  echo -e "${YELLOW}Skipping YAML Linting - yamllint not installed${NC}"
fi

if command -v ansible-lint &> /dev/null; then
  run_test "Ansible Linting" "ansible-lint ." ""
else
  echo -e "${YELLOW}Skipping Ansible Linting - ansible-lint not installed${NC}"
fi

# Test 1: Syntax Check
run_test "Syntax Check" "ansible-playbook playbooks/site.yml --syntax-check" ""

# Test 2: Dotfiles Linking Test
run_test "Dotfiles Linking Test" "ansible-playbook playbooks/test_dotfiles.yml"

# Test 3: Installation Tasks Test
run_test "Installation Tasks Test" "ansible-playbook playbooks/test_install.yml"

# Test 4: Shell Commands Test
run_test "Shell Commands Test" "ansible-playbook playbooks/test_shell_commands.yml"

# Test 5: Role Integration Test (if it exists)
if [ -f "playbooks/test_role_integration.yml" ]; then
  run_test "Role Integration Test" "ansible-playbook playbooks/test_role_integration.yml --check"
fi

# Test 6: Molecule Tests (if available)
if command -v molecule &> /dev/null; then
  # Find all roles with molecule tests
  for role_dir in roles/*/molecule; do
    if [ -d "$role_dir" ]; then
      role_name=$(basename $(dirname "$role_dir"))
      echo -e "${YELLOW}Running Molecule Test: $role_name...${NC}"
      if (cd "$(dirname "$role_dir")" && molecule --base-config=/home/roadhouse/code/dotfiles/ansible/molecule/default/molecule.yml test); then
        echo -e "${GREEN}✓ Molecule Test: $role_name passed${NC}\n"
      else
        echo -e "${RED}✗ Molecule Test: $role_name failed${NC}\n"
      fi
    fi
  done
fi

# Summary
echo -e "${BLUE}=== Test Summary ===${NC}"
echo -e "All tests have been executed. Review the output above for any failures."
echo -e "${GREEN}To run specific tests:${NC}"
echo -e "  ansible-playbook playbooks/test_dotfiles.yml     # Test dotfiles linking"
echo -e "  ansible-playbook playbooks/test_install.yml     # Test installation tasks"
echo -e "  ansible-playbook playbooks/test_shell_commands.yml # Test shell commands"
echo -e "  cd roles/[role_name] && molecule test         # Run molecule tests for a role"

echo -e "${BLUE}=== End of Tests ===${NC}"
