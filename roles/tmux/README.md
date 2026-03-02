# Tmux Role

This role installs and configures `tmux` for this dotfiles repository.

It manages three things:

1. `tmux` package installation per OS
2. the linked configuration under `~/.config/tmux/`
3. TPM and TPM-managed plugins under `~/code/tmux-plugins/`

## What This Role Sets Up

- prefix remapped to `C-a`
- vi-style copy mode
- pane and window navigation helpers
- TokyoNight Storm themed status bar and UI colors
- TPM plugin manager
- plugin directory outside the dotfiles repository
- session persistence with `tmux-resurrect` and `tmux-continuum`
- clipboard integration and search/open helpers via TPM plugins

## Managed Paths

- config: `~/.config/tmux/`
- TPM: `~/code/tmux-plugins/tpm`
- TPM plugins: `~/code/tmux-plugins/`

## Managed Plugins

- `tmux-plugins/tpm`
- `tmux-plugins/tmux-resurrect`
- `tmux-plugins/tmux-continuum`
- `tmux-plugins/tmux-yank`
- `tmux-plugins/tmux-open`
- `tmux-plugins/tmux-copycat`

## Role Variables

Defaults live in [defaults/main.yml](/home/roadhouse/code/dotfiles/roles/tmux/defaults/main.yml).

- `tmux_code_dir`
- `tmux_plugins_dir`
- `tmux_tpm_repo`
- `tmux_tpm_version`
- `tmux_tpm_path`

## Usage

Run only this role:

```bash
ansible-playbook -i inventory playbooks/development.yml --tags tmux
```

If `tmux` is already installed and you only want the config and plugins:

```bash
ansible-playbook -i inventory playbooks/development.yml --tags tmux --skip-tags install
```

Reload the active tmux session manually:

```bash
tmux source-file ~/.config/tmux/tmux.conf
```

## Notes

- TPM itself is stored in `~/code/tmux-plugins/tpm`.
- TPM-managed plugins are intentionally kept out of the dotfiles repo.
- `tmux-continuum` is configured with automatic restore enabled.
