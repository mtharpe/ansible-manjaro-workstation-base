# Changelog

## Unreleased
- Convert role layout to mirror `ansible-fedora-workstation-base` (top-level `templates/`, `handlers/`, `meta/`, `molecule/`, `Makefile`)
- Translate Fedora-specific tooling to Manjaro/Arch equivalents: `dnf`→`pacman`/`yay`, `yum_repository`/`rpm_key`→ AUR via `yay`, `firewalld`→`iptables`/`ufw`, RPM Fusion→ multimedia codecs in `extra`/AUR
- Pin Molecule image to `manjarolinux/base:latest`
- Replace legacy roles (`packages`, `apps`, `gnome` with extension subscripts) with `common`/`third-party`/`gnome` mirroring Fedora
- Drop custom `library/yay` module (replaced by `kewlfft.aur` collection or `community.general.pacman` with AUR helper)
- Drop `vagrant/Vagrantfile`, `site.yml`
