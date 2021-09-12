#!/bin/bash

USER="vagrant"

if [ ! -f /bin/ansible ]; then
    sudo pacman -Syy --noconfirm ansible 
fi

if [ ! -f /etc/sudoers.d/tharpem ]; then
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/${USER}
fi

until ansible-playbook --extra-vars "local_user=${USER}" site.yml; do
  echo Ansible run disrupted, retrying in 10 seconds...
  sleep 10
done

sudo -u gdm dbus-launch --exit-with-session gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false