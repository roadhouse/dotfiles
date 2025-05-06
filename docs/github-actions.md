# GitHub Actions for Ansible Testing

This guide explains how to use GitHub Actions to automatically test your Ansible roles whenever changes are pushed to your repository.

## Overview

GitHub Actions is a CI/CD (Continuous Integration/Continuous Deployment) platform that allows you to automate your testing and deployment workflows directly from your GitHub repository.

## Setup

### 1. Required Tools for Local Development

To develop and test GitHub Actions workflows locally, install these tools:

```bash
pip install molecule molecule-docker ansible-lint yamllint
```

These tools help you:
- **molecule**: Framework for testing Ansible roles
- **molecule-docker**: Driver for running tests in Docker containers
- **ansible-lint**: Linter for Ansible playbooks and roles
- **yamllint**: YAML syntax checker

### 2. GitHub Actions Workflow File

The workflow file is located at `.github/workflows/ansible-test.yml` and defines two jobs:

1. **Lint**: Checks YAML syntax and Ansible best practices
2. **Test**: Runs all the test playbooks

### 3. Workflow Triggers

The workflow is triggered:
- On push to main/master branches (only when changes are made to the ansible directory)
- On pull requests to main/master branches (only when changes are made to the ansible directory)
- Manually via the GitHub Actions interface

## Running Tests Locally

Before pushing changes, you can run the same tests locally:

```bash
# Install dependencies
pip install ansible ansible-lint yamllint

# Lint YAML files
cd /home/roadhouse/code/dotfiles
yamllint ansible/

# Lint Ansible files
ansible-lint ansible/

# Run test playbooks
cd ansible
./run_tests.sh
```

## Molecule Testing (Advanced)

For more advanced testing, you can use Molecule to test individual roles:

```bash
# Install Molecule
pip install molecule molecule-docker

# Initialize Molecule for a role
cd ansible/roles/git
molecule init scenario default -d docker

# Run Molecule tests
molecule test
```

## Benefits of CI/CD Testing

1. **Automated Validation**: Changes are automatically tested
2. **Early Error Detection**: Catch issues before they reach production
3. **Documentation**: Tests serve as executable documentation
4. **Consistency**: Ensures consistent environment setup
5. **Confidence**: Gives confidence when making changes

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Ansible Lint Documentation](https://ansible-lint.readthedocs.io/)
- [Molecule Documentation](https://molecule.readthedocs.io/)
