#!/bin/bash

USER=`whoami`

sudo pacman -Syyu --noconfirm

if [ ! -f /bin/ansible ]; then
    sudo pacman-mirrors --country United_States
    sudo pacman -Syy --noconfirm ansible 
fi

if [ ! -f /etc/sudoers.d/${USER} ]; then
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/${USER} 
fi

until ansible-playbook --extra-vars "local_user=${USER}" site.yml; do
  echo Ansible run disrupted, retrying in 10 seconds...
  sleep 10
done

# Detect remote connection and do not run GDM settings because you will be disconnected!
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE=remote/ssh
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) SESSION_TYPE=remote/ssh;;
  esac
fi

if [ SESSION_TYPE = "remote/ssh" ]; then
  sudo -u gdm dbus-launch --exit-with-session gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false
fi
