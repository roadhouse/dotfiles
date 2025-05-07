# Ansible Testing Documentation

This document explains how to test the Ansible roles and playbooks in this repository.

## Testing Infrastructure Overview

The testing infrastructure is designed to be simple, consistent, and maintainable. It consists of:

1. **Individual Test Playbooks** - For testing specific components
2. **Shared Configuration** - Common test settings in `vars/test_config.yml`
3. **Comprehensive Test Suite** - A unified playbook that runs all tests
4. **Test Script** - A bash script (`run_tests.sh`) that automates running all tests
5. **GitHub Actions Integration** - Automated CI/CD testing

## Running Tests Locally

### Option 1: Run All Tests

The simplest way to run all tests is to use the test script:

```bash
cd /path/to/dotfiles
./ansible/run_tests.sh
```

This will run all tests in sequence with color-coded output showing which tests passed or failed.

### Option 2: Run the Comprehensive Test Playbook

```bash
cd /path/to/dotfiles
ansible-playbook ansible/playbooks/test_all.yml
```

### Option 3: Run Individual Test Playbooks

Test specific components:

```bash
# Test dotfiles linking
ansible-playbook ansible/playbooks/test_dotfiles.yml

# Test installation tasks
ansible-playbook ansible/playbooks/test_install.yml

# Test shell commands
ansible-playbook ansible/playbooks/test_shell_commands.yml

# Test role integration
ansible-playbook ansible/playbooks/test_role_integration.yml
```

## Using Tags for Selective Testing

You can use tags to test only specific roles or components:

```bash
# Test only Git-related tasks
ansible-playbook ansible/playbooks/test_all.yml --tags git

# Test only Ruby-related tasks
ansible-playbook ansible/playbooks/test_all.yml --tags ruby

# Test only dotfiles linking
ansible-playbook ansible/playbooks/test_all.yml --tags dotfiles
```

## Advanced Testing Options

### Dry Run Testing

To see what changes would be made without actually making them:

```bash
# Add --check flag to see what would change without making changes
ansible-playbook ansible/playbooks/test_dotfiles.yml --check

# Add --diff to also see the differences
ansible-playbook ansible/playbooks/test_dotfiles.yml --check --diff
```

### Molecule Testing

For roles with Molecule tests (like golang):

```bash
cd /path/to/dotfiles/ansible/roles/golang
molecule test
```

### Linting

To check syntax and best practices:

```bash
# Run yamllint
cd /path/to/dotfiles
yamllint ansible/

# Run ansible-lint
ansible-lint ansible/
```

## Continuous Integration with GitHub Actions

The repository includes a GitHub Actions workflow (`.github/workflows/ansible-test.yml`) that automatically runs all tests when changes are pushed to the repository.

The workflow includes:

1. **Linting** - Checks YAML syntax and Ansible best practices
2. **Syntax Check** - Verifies playbook syntax
3. **Test Playbooks** - Runs all test playbooks

You can also manually trigger the workflow from the GitHub Actions tab.

## Adding New Tests

To add tests for a new role:

1. Update the individual test playbooks to include tasks for the new role
2. Add appropriate tags to make selective testing possible
3. Ensure the tests work in both local and GitHub Actions environments

## Troubleshooting

- **Path Issues**: Make sure paths are correctly set in the `vars/test_config.yml` file
- **Missing Dependencies**: Install required tools with `pip install ansible ansible-lint yamllint molecule molecule-plugins[docker]`
- **Permission Issues**: Ensure the `run_tests.sh` script is executable (`chmod +x ansible/run_tests.sh`)

## Test Directory Structure

```
ansible/
├── playbooks/
│   ├── test_all.yml           # Comprehensive test suite
│   ├── test_dotfiles.yml      # Tests dotfiles linking
│   ├── test_install.yml       # Tests installation tasks
│   ├── test_role_integration.yml # Tests role integration
│   └── test_shell_commands.yml # Tests shell commands
├── vars/
│   └── test_config.yml        # Shared test configuration
└── run_tests.sh               # Test automation script
```
