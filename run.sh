#!/bin/bash

USER=`whoami`

if [ ! -f /bin/ansible ]; then
    sudo pacman -Syy --noconfirm ansible 
fi

ansible-playbook --extra-vars "local_user=${USER}" site.yml