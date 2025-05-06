# Personal Notebook Ansible Playbooks

Run from project root or the `ansible/` directory:

```bash
ansible-playbook -i inventory playbooks/site.yml --ask-become-pass
```

The config file `ansible/ansible.cfg` pins the `roles_path` to the local `roles/` directory so Ansible can locate the bundled roles.
