# Personal Notebook Ansible Setup

This repository contains Ansible roles and playbooks for setting up a personal development environment with various tools and configurations.

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

### Molecule Testing (Recommended)

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

### Legacy Test Script

A test script is also available for running traditional Ansible test playbooks:

```bash
cd ansible
./run_tests.sh
```

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
pip install ansible molecule molecule-plugins[docker] docker
```

#### Molecule Testing

The project now uses Molecule for testing roles in isolated Docker containers. This provides a more reliable and consistent testing environment.

```bash
# Run Molecule tests for all roles
cd ansible
molecule test
```

The Molecule tests use a dynamic verification approach that:

1. Automatically detects which roles are being tested
2. Includes role-specific verification tasks
3. Verifies that each role's components are correctly installed and configured

To add verification for a new role, create a `molecule/verify.yml` file in the role directory with the specific verification tasks for that role.

#### Linting (Optional)

For code quality checks, you can install and run linting tools:

```bash
pip install ansible-lint yamllint

# Check YAML syntax
yamllint ansible/

# Check Ansible best practices
ansible-lint ansible/
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

## Continuous Integration

This repository uses GitHub Actions for automated testing on every push and pull request.

### GitHub Actions Workflow

The workflow in `.github/workflows/ansible-test.yml` automatically runs:

1. **Linting**: Checks YAML syntax and Ansible best practices
2. **Molecule Tests**: Runs the Molecule tests against the roles

This ensures that changes to the Ansible roles are tested before they are merged into the main branch.

To manually trigger the workflow, go to the Actions tab in the GitHub repository and select "Run workflow".

---
Made with ❤️ 🤖 🐱
