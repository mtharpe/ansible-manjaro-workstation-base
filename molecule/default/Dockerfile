FROM docker.io/manjarolinux/base:latest

# Refresh keyring + databases, then install base tools
RUN pacman -Sy --noconfirm archlinux-keyring manjaro-keyring \
    && pacman-key --init \
    && pacman -Syu --noconfirm \
    && pacman -S --noconfirm python ansible openssh sudo

# Clean pacman cache
RUN pacman -Scc --noconfirm
