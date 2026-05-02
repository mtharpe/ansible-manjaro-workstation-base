[![CircleCI](https://circleci.com/gh/mtharpe/ansible-manjaro-workstation-base/tree/main.svg?style=svg)](https://circleci.com/gh/mtharpe/ansible-manjaro-workstation-base/tree/main)

# Arch-family Workstation Base

Ansible playbook and role collection that automates the setup of an **Arch-family**
GNOME workstation for development and daily use. Supported distros include
**Arch Linux**, **Manjaro**, **CachyOS**, **EndeavourOS**, and **Garuda** —
anything that reports `os_family: Archlinux`.

> This repo is named `ansible-manjaro-workstation-base` for historical reasons;
> the playbook itself is distro-neutral within the Arch family.

## What this does

Configures an Arch-family workstation with:

- **Common packages** — developer tooling, fonts, multimedia codecs, system utilities (`roles/common`)
- **Third-party apps** — Chrome, VS Code, Slack, Zoom, Docker, etc., gated by feature flags (`roles/third-party`)
- **GNOME settings** — sensible dconf defaults, dark theme, workspace layout (`roles/gnome`)
- **Shell setup** — bash or fish with TPM, Starship, FiraCode Nerd Font (toggle in `vars/vars.yml`)
- **Hardening** — sshd config, fail2ban, ufw desktop firewall (opt-in)

AUR-only software (Chrome, VS Code, Slack, Zoom, gcloud-sdk, etc.) is installed
via the user's available AUR helper. The playbook auto-detects `paru` (CachyOS
default) or `yay` (Manjaro / EndeavourOS default), and bootstraps `yay-bin`
from the AUR via `makepkg` on vanilla Arch where neither is in the official repos.

The pacman keyring step also adapts: `archlinux-keyring` is refreshed everywhere,
and the distro-specific keyrings (`manjaro-keyring`, `cachyos-keyring`,
`endeavouros-keyring`) are only refreshed on their respective distros.

## Requirements

- Any Arch-family distro (Arch, Manjaro, CachyOS, EndeavourOS, Garuda, …)
- A user account with sudo access
- Internet access for package installs (and for AUR helper bootstrap on vanilla Arch)
- `multilib` enabled in `/etc/pacman.conf` if you want Steam

## Quick start

1. Clone the repository:

   ```sh
   git clone https://github.com/mtharpe/ansible-manjaro-workstation-base.git
   cd ansible-manjaro-workstation-base
   ```

2. Edit `vars/vars.yml` to set your `local_user` and toggle features:

   ```yaml
   local_user: yourusername
   install_chrome: true
   install_vscode: true
   install_fish: true
   ```

3. Run the bootstrap script (installs Ansible if missing, applies the playbook):

   ```sh
   ./run.sh
   ```

   Or invoke ansible directly:

   ```sh
   sudo pacman -Syy --noconfirm ansible
   ansible-playbook --extra-vars "local_user=$USER" setup_workstation.yml
   ```

## Feature flags

All toggles live in `vars/vars.yml`. The most useful ones:

| Flag | Default | What it controls |
|------|---------|------------------|
| `install_chrome` | `true` | Google Chrome (AUR `google-chrome`) |
| `install_vscode` | `true` | Visual Studio Code (AUR `visual-studio-code-bin`) |
| `install_slack` | `true` | Slack desktop (AUR `slack-desktop`) |
| `install_zoom` | `true` | Zoom (AUR `zoom`) |
| `install_docker` | `false` | docker + docker-compose (otherwise podman is the default) |
| `install_gcloud` | `false` | Google Cloud SDK (AUR) + kubectl |
| `install_fish` | `true` | Fish shell + Pure prompt + Fisher |
| `install_bash` | `false` | Bash dotfiles |
| `install_nerd_font` | `true` | FiraCode Nerd Font for prompts/icons |
| `install_eza` | `true` | `eza` (modern `ls` replacement) |
| `enable_sshd` | `false` | Enable and harden sshd |
| `enable_fail2ban` | `true` | Enable fail2ban with desktop-friendly defaults |

## Testing with Molecule

Two Molecule scenarios converge the playbook against a containerized
`manjarolinux/base:latest` (the Manjaro path is the most-exercised flavor).
The role detects `is_container` from `ansible_facts['virtualization_type']`
and skips the `gnome` role plus any task that would try to start systemd
services (sshd, fail2ban, docker) or hit netfilter (ufw), so container runs
stay fast and don't fail on operations that aren't possible in an unprivileged
container. To test against vanilla Arch / CachyOS / EndeavourOS, swap the
`image:` field in `molecule/default/molecule.yml` to e.g. `archlinux:latest`
or `cachyos/cachyos-v3:latest`.

```sh
make test-podman          # full create/converge/idempotence/verify on podman
make test-docker          # same on docker
make syntax-podman        # parse-only check
make idempotence-podman   # converge twice, expect zero changes the second time
```

## Linting and CI

CircleCI runs four checks on every push (see `.circleci/config.yml`):

- `ansible-lint` — playbook & role linting
- `yamllint` — YAML quality
- `ansible-playbook --syntax-check` — playbook parses
- `shellcheck` — shell scripts

Run them locally:

```sh
ansible-lint .
yamllint .
shellcheck run.sh
ansible-playbook --syntax-check setup_workstation.yml
```

## Customization

- Add/remove packages: `roles/common/tasks/packages.yml`
- System tweaks: `roles/common/tasks/system.yml` and `roles/common/tasks/harden.yml`
- Drop dotfiles into `templates/` and reference them from a role task

## Related

- [`ansible-fedora-workstation-base`](https://github.com/mtharpe/ansible-fedora-workstation-base) — Fedora 43+
- [`ansible-ubuntu-workstation-base`](https://github.com/mtharpe/ansible-ubuntu-workstation-base) — Ubuntu 24.04+
- [`ansible-manjaro-workstation-base`](https://github.com/mtharpe/ansible-manjaro-workstation-base) — Arch family: Arch, Manjaro, CachyOS, EndeavourOS, Garuda (this repo)

## License

MIT License. See [LICENSE](LICENSE) for details.
