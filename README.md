# Personal Notebook Ansible Setup

This repository contains Ansible roles and playbooks for setting up a personal development environment with various tools and configurations.

## Structure

- `playbooks/`: Contains the main playbook (`site.yml`) and test playbooks
- `roles/`: Contains modular roles for different applications and tools
- `roles/common/tasks/includes/`: Contains reusable tasks shared across roles

## Running the Playbook

To apply all configurations, run from the project root or the `ansible/` directory:

```bash
ansible-playbook -i inventory playbooks/site.yml --ask-become-pass
```

To apply specific roles using tags:

```bash
ansible-playbook -i inventory playbooks/site.yml --tags git,ruby,nvim --ask-become-pass
```

## Testing

This repository includes comprehensive testing capabilities to verify role functionality before applying changes to your system.

### Running All Tests Locally

A test script is provided to run all tests in sequence:

```bash
cd ansible
./run_tests.sh
```

This will run all test playbooks and provide a color-coded summary of results.

### Individual Test Playbooks

#### Testing Dotfiles Linking

Test the reusable dotfiles linking task across roles:

```bash
ansible-playbook playbooks/test_dotfiles.yml --check -v
```

#### Testing All Role Tasks

Run a comprehensive test of all roles:

```bash
ansible-playbook playbooks/test_all.yml -v
```

#### Testing Specific Roles

Test only specific roles using tags:

```bash
# Test only git role tasks
ansible-playbook playbooks/test_all.yml -v --tags git

# Test only installation tasks across all roles
ansible-playbook playbooks/test_all.yml -v --tags test --skip-tags config
```

#### Dry Run (Check Mode)

Simulate changes without making them:

```bash
# Simulate changes without making them
ansible-playbook playbooks/site.yml --check --diff --tags git,ruby
```

#### Syntax Check

Verify your playbook syntax without making any changes:

```bash
ansible-playbook playbooks/site.yml --syntax-check
```

### Advanced Testing Tools

For more comprehensive testing, you can install additional tools:

```bash
pip install ansible-lint yamllint molecule molecule-docker
```

These tools enable:

#### Linting

Check YAML syntax and Ansible best practices:

```bash
# Check YAML syntax
yamllint ansible/

# Check Ansible best practices
ansible-lint ansible/
```

#### Molecule Testing

Test individual roles in isolated environments:

```bash
# Initialize Molecule for a role
cd ansible/roles/git
molecule init scenario default -d docker

# Run Molecule tests
molecule test
```

## Role Organization

Roles are organized into logical sections:

1. **Core system**: common
2. **Base components**: git, xorg, zsh, nushell, tmux, touchpad
3. **Development tools**: nvim, ruby, golang
4. **Shell enhancements**: starship, atuin
5. **Desktop environment**: i3, autorandr, alacritty, rofi

## Reusable Tasks

The `roles/common/tasks/includes/` directory contains reusable tasks that can be shared across roles:

- `link_dotfiles.yml`: A reusable task for linking configuration files from role directories to the home directory

### Using the Reusable Dotfiles Task

```yaml
- name: 🔗 Link git dotfiles
  include_tasks: ../../common/tasks/includes/link_dotfiles.yml
  vars:
    dotfiles:
      - { src: 'gitconfig', dest: '.gitconfig' }
    role_name: git
```

---
Made with ❤️ 🤖 🐱
