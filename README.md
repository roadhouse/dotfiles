# Personal Notebook Ansible Setup

[![Ansible Test](https://github.com/roadhouse/dotfiles/actions/workflows/ansible-test.yml/badge.svg)](https://github.com/roadhouse/dotfiles/actions/workflows/ansible-test.yml) ![Ansible](https://img.shields.io/badge/ansible-%3E%3D2.15-blue) ![Python](https://img.shields.io/badge/python-%3E%3D3.10-blue) ![OS Support](https://img.shields.io/badge/os-ubuntu%2024.04-orange)

This repository contains Ansible roles and playbooks for setting up a personal development environment with various tools and configurations.

## Prerequisites

Before using this repository, ensure you have the following:

### System Requirements
- **Operating System**: Ubuntu 24.04 (primary target) or other Debian-based distributions
- **Python**: 3.10 or newer
- **Ansible**: 2.15 or newer
- **Nerd Font**: For proper icon display in task names and documentation

### For Development and Testing
- **Docker**: 24.0 or newer (required for Molecule tests)
- **Pip packages**: `ansible molecule molecule-plugins[docker] docker`

### Installation

```bash
# Install Ansible and related tools
pip install ansible

# For development and testing
pip install molecule molecule-plugins[docker] docker ansible-lint yamllint
```

## Git File Management Notes

### Atuin Config

To exclude personal Atuin server settings from git tracking:

```bash
# Ignore changes to atuin config file
git update-index --skip-worktree ansible/roles/atuin/files/config/config.toml

# Resume tracking changes when needed
git update-index --no-skip-worktree ansible/roles/atuin/files/config/config.toml
```

## Structure

- `playbooks/`: Contains multiple playbooks for different environments:
  - `development.yml`: Core system and development tools
  - `desktop.yml`: Desktop environment configuration
  - `servers.yml`: Server infrastructure setup
  - `languages.yml`: Programming languages with explicit versions
- `roles/`: Contains modular roles for different applications and tools
- `roles/common/tasks/includes/`: Contains reusable tasks shared across roles

## Running the Playbooks

This repository contains multiple playbooks for different environments and purposes.

### Core System Setup

To set up the core system with development tools, run:

```bash
ansible-playbook -i inventory playbooks/development.yml --ask-become-pass
```

### Desktop Environment Setup

To configure the desktop environment (i3, rofi, etc.), run:

```bash
ansible-playbook -i inventory playbooks/desktop.yml --ask-become-pass
```

### Server Infrastructure Setup

To set up server infrastructure tools (k3s, etc.), run:

```bash
ansible-playbook -i inventory playbooks/servers.yml --ask-become-pass
```

### Programming Languages Setup

To install programming languages with specific versions, run:

```bash
ansible-playbook -i inventory playbooks/languages.yml --ask-become-pass
```

### Using Tags

You can apply specific roles using tags with any playbook:

```bash
ansible-playbook -i inventory playbooks/development.yml --tags git,ruby,nvim --ask-become-pass
```

## Testing

This repository includes comprehensive testing capabilities to verify role functionality before applying changes to your system.

### Molecule Testing

Molecule provides a standardized way to test Ansible roles in isolated Docker containers:

```bash
cd ansible
molecule test
```

This will:
1. Create a Docker container with Ubuntu 24.04
2. Apply the roles defined in the converge.yml file
3. Verify that each role's components are correctly installed and configured
4. Clean up the test environment

The Molecule tests use a dynamic verification approach that:

1. Automatically detects which roles are being tested
2. Includes role-specific verification tasks
3. Verifies that each role's components are correctly installed and configured

#### Testing Specific Roles

To test a specific role with Molecule:

```bash
cd ansible/roles/golang  # Replace with the role you want to test
molecule test
```

#### Adding Verification for New Roles

To add verification for a new role, create a `verify_tasks.yml` file in the role's `molecule/default/` directory with specific verification tasks.

### Other Testing Methods

#### Dry Run (Check Mode)

Use Ansible's check mode to simulate changes without making them:

```bash
# Simulate changes without making them
ansible-playbook playbooks/site.yml --check --diff --tags git,ruby
```

#### Syntax Check

Verify your playbook syntax without making any changes:

```bash
ansible-playbook playbooks/site.yml --syntax-check
```

#### Linting

For code quality checks, install and run linting tools:

```bash
pip install ansible-lint yamllint

# Check YAML syntax
yamllint ansible/

# Check Ansible best practices
ansible-lint ansible/
```

## Role Organization

Roles are organized into logical sections with specific purposes:

| Category | Role | Purpose/Key Tasks |
|----------|------|-------------------|
| **Core System** | common | Base system configuration and shared tasks |
| **Base Components** | git | Installs Git, configures global settings and aliases |
| | xorg | Sets up X11 configuration and input device settings |
| | zsh | Installs and configures Zsh shell with plugins |
| | nushell | Modern shell alternative with structured data handling |
| | tmux | Terminal multiplexer with custom key bindings |
| | touchpad | Configures touchpad settings for laptops |
| **Development Tools** | nvim | Installs Neovim editor with plugins and custom configuration |
| **Programming Languages** | ruby | Installs Ruby, Bundler, and development tools |
| | golang | Installs Go language toolchain and sets GOPATH |
| **Shell Enhancements** | starship | Cross-shell prompt with Git integration |
| | atuin | Shell history search and sync tool |
| **Desktop Environment** | i3 | Tiling window manager with custom keybindings |
| | autorandr | Automatic display configuration |
| | alacritty | GPU-accelerated terminal emulator |
| | ghostty | Modern GPU-accelerated terminal with advanced features |
| | rofi | Application launcher and window switcher |

## Nerd Font Icons

This project uses Nerd Font icons throughout the Ansible tasks for better visual organization. A Nerd Font-compatible terminal and editor are recommended for the best experience.

### Icon Standards

The project follows these icon standards:

| Task Type | Icon | Description |
|-----------|------|-------------|
| Debian-specific installation | | Debian logo for Debian tasks |
| macOS-specific installation | | Apple logo for macOS tasks |
| Configuration/Linking | | Link icon for configuration file tasks |
| Repository operations | | Branch icon for repository tasks |
| Building | | Hammer icon for build tasks |
| Service management | | Server icon for service tasks |

A complete reference can be found in `/ansible/roles/common/files/icon_reference.md`

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

## Variable Management and Secrets

### Variable Hierarchy

This project uses Ansible's variable precedence system:

1. **Role defaults** (`roles/[role_name]/defaults/main.yml`): Default values that can be overridden
2. **Group variables** (`group_vars/[group_name].yml`): Settings for specific host groups
3. **Host variables** (`host_vars/[hostname].yml`): Host-specific settings

### Managing Secrets

For sensitive information like API keys or passwords:

```bash
# Create an encrypted file
ansible-vault create ansible/group_vars/all/vault.yml

# Edit an encrypted file
ansible-vault edit ansible/group_vars/all/vault.yml

# Run playbooks with vault password
ansible-playbook -i inventory playbooks/site.yml --ask-vault-pass
```

For files that contain sensitive information but need local modifications:

```bash
# Ignore changes to a file
git update-index --skip-worktree [path/to/sensitive/file]

# Resume tracking changes when needed
git update-index --no-skip-worktree [path/to/sensitive/file]
```

## Continuous Integration

This repository uses GitHub Actions for automated testing on every push and pull request.

### GitHub Actions Workflow

The workflow in `.github/workflows/ansible-test.yml` automatically runs:

1. **Linting**: Checks YAML syntax and Ansible best practices
2. **Syntax Check**: Verifies playbook syntax
3. **Molecule Tests**: Runs the Molecule tests against the roles

This ensures that changes to the Ansible roles are tested before they are merged into the main branch.

To manually trigger the workflow, go to the Actions tab in the GitHub repository and select "Run workflow".

---
Made with ❤️ 🤖 🐱
