#!/bin/bash

USER=`whoami`

if [ ! -f /bin/ansible ]; then
    sudo pacman -Syy --noconfirm ansible 
fi

ansible-playbook --extra-vars "local_user=${USER}" site.yml

sudo -u gdm dbus-launch --exit-with-session gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false

