# Tmux Role

This role installs and configures tmux (terminal multiplexer).

## Role Variables

None currently defined.

## Example Playbook

```yaml
- hosts: workstations
  roles:
    - { role: tmux, tags: [tmux] }
```

## Usage

After installation, tmux will be available with the configuration in `~/.config/tmux/`.

To run only this role:

```bash
ansible-playbook -i inventory playbooks/site.yml --tags tmux
```
