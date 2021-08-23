![Ansible Lint](https://github.com/mtharpe/ansible-manjaro-workstation-base/workflows/Ansible%20Lint/badge.svg)

# Manjaro Workstation Base

This is an opinionated playbook to setup a Manjaro Gnome workstation with everything you need.

## Quick Setup

Follow these steps to install Ansible, and run the playbook:

```
$> sudo pacman -Syy ansible

$> git pull https://github.com/mtharpe/ansible-manjaro-workstation-base.git

$> cd ansible-manjaro-workstation-base

$> ansible-playbook --extra-vars local_user=<username>

```

or

```

$> git pull https://github.com/mtharpe/ansible-manjaro-workstation-base.git

$> cd ansible-manjaro-workstation-base

$> ./run.sh

```