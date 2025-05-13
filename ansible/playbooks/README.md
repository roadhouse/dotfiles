# Personal Notebook Ansible Playbooks

Run from project root or the `ansible/` directory:

```bash
ansible-playbook -i inventory playbooks/development.yml --ask-become-pass
```

The config file `ansible/ansible.cfg` pins the `roles_path` to the local `roles/` directory so Ansible can locate the bundled roles.

## Available Playbooks

- `development.yml`: Core system and development tools
- `desktop.yml`: Desktop environment configuration
- `servers.yml`: Server infrastructure setup
- `languages.yml`: Programming languages with explicit versions

### Languages Playbook

The languages playbook installs programming languages with specific versions explicitly defined in the playbook:

```bash
ansible-playbook -i inventory playbooks/languages.yml --ask-become-pass
```

This playbook currently includes:

- Ruby (version 3.4.3)
- Golang (version 1.24)
