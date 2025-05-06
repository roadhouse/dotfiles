# Golang Role

This role installs Golang on Ubuntu systems using the official PPA.

## Role Variables

- `golang_version`: Version of Golang to install (default: "1.24")
- `golang_bin_path`: Path to Golang binaries (default: "/usr/lib/go-{{ golang_version }}/bin")

## Example Playbook

```yaml
- hosts: workstations
  roles:
    - { role: golang, golang_version: "1.24" }
```

## Usage

After installation, Golang will be available at `/usr/lib/go-1.24/bin/go` by default.

To run only this role:

```bash
ansible-playbook -i inventory playbooks/site.yml --tags golang
```
