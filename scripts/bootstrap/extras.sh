#!/usr/bin/env bash
set -eu -o pipefail


pacman -Syy

# pip/python section

pip3 install --user --break-system-packages \
    streamdeck \
    monitorcontrol \


# pillow for streamdeck
pacman -S --noconfirm \
    python-ruamel-yaml \
    python-boto3 \
    python-pillow \
    python-websockets \


# evince or okular for a PDF reader -- trying okular

# Useful in day to day
# fuse is useful for anything that uses appimage
# find that chromium is useful on certain websites compared to firefox

# not installing
# thunderbird

# fuse3 - need to look

# group with a lot of utils that help with compiling
# or shell in general
pacman -S --noconfirm \
	base-devel

# mpv -> vlc
# wine-staging or wine
pacman -S --noconfirm \
    mediainfo \
    git-delta \
    bfs \
    libnotify \
    playerctl \
    ark \
    jq \
    bc \
    croc \
    gron \
    gimp \
    libreoffice-fresh \
    okular \
    fzf \
    bat \
    keepassxc \
    freerdp \
    perl-image-exiftool \
    openssl \
    fuse2 \
    pciutils \
    chromium \
    ncdu \
    moreutils \
    obs-studio \
    exfat-utils \
    unrar \
    cmus \
    qbittorrent \
    vlc \
    signal-desktop \
    obsidian \
    kolourpaint \
    pngquant \
    progress \
    shellcheck \


# wine
# needs multilib enabled
#pacman -S --noconfirm \
#    wine-staging \
#    winetricks \
#    wine-mono

# icons
pacman -S --noconfirm \
    ttf-iosevka-nerd \
    ttf-font-awesome

# streamdeck thing and yubikey
pacman -S --noconfirm \
    libusb \
    hidapi \
    xf86-input-wacom

# protobuf dev
pacman -S --noconfirm \
    protobuf

# yubikey
# GUI installed cos
pacman -S --noconfirm \
    yubikey-manager \
    yubikey-personalization
# yubikey-manager-qt \
# yubikey-personalization-gui

# VNC Server
#pacman -S --noconfirm \
#    x11vnc

# Early OOM daemon that runs in userspace
pacman -S --noconfirm earlyoom
systemctl enable --now earlyoom

# Samba
pacman -S --noconfirm \
    smbclient \
    cifs-utils

# Misc
pacman -S --noconfirm \
    cowsay \
    figlet \
    neofetch

# VPN

#pacman -S --noconfirm \
#    openvpn \
#    networkmanager-openvpn

pacman -S --noconfirm \
    wireguard-tools

# Networking
pacman -S --noconfirm \
    ngrep \
    nmap \
    wireshark-qt \
    wireshark-cli \
    inetutils

# Security

# missing bcrypt
pacman -S --noconfirm \
    gnupg \
    pwgen \
    firejail \
    bubblewrap

# DB clients
# dnf install \
#     postgresql \
#     sqlite

# Dev tools & networking tools

# not installed
# lsb
# uuid -> util-linux
# xar
pacman -S --noconfirm \
    binutils \
    cmake \
    go \
    gcc \
    gdb \
    glibc \
    lsof \
    ltrace \
    make \
    psmisc \
    lsb-release \
    ruby \
    hunspell \
    strace \
    util-linux \
    valgrind \
    python-pylint \
    python \
    python-pip \
    rustup

# for python2
# install via AUR

# proxychains
# install from https://github.com/rofl0r/proxychains-ng
# or from pacman
# or aur


# TODO: podman
#pacman -S --noconfirm \
#    docker

# grab from AUR
# code

# spotify
# https://aur.archlinux.org/packages/spotify/
# curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | gpg --import -

# zsh
pacman -S --noconfirm \
    zsh

# discord
pacman -S --noconfirm \
    discord


rustup toolchain install
rustup default stable

# steam
# https://wiki.archlinux.org/title/steam#Installation
# enable multilib
# https://wiki.archlinux.org/title/Official_repositories#multilib

#/etc/pacman.conf

#[multilib]
#Include = /etc/pacman.d/mirrorlist

# will need to install 32 bit nvidia drivers too

#pacman -S --noconfirm \
#steam \
#libpng12

# if using calling software and having issues with sound (speakers not being detected during calls)
# edit /usr/share/pipewire/media-session.d/alsa-monitor.conf
# uncomment #audio.format = "S16LE"
# restart software / pipewire

# WIREGUARD
#
# sudo bash
# umask 077
# mkdir -p /etc/wireguard
# wg genkey | tee /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey

# create wg0.conf

# privatekey="$(cat /etc/wireguard/privatekey)"
# cat <<EOF > /etc/wireguard/wg0.conf
# [Interface]
# PrivateKey = $privatekey
# Address = 
# EOF

# to import to network manager
# do all nmcli commands as root
# nmcli con import type wireguard file /etc/wireguard/wg0.conf

# IF USING DNS
# nmcli con modify wg0 ipv4.dns DNS
# nmcli con modify wg0 ipv4.dns-search '~'

# ONLY IPV4
# nmcli con modify wg0 ipv4.may-fail no
# nmcli con modify wg0 ipv6.method ignore


# once croc is setup
# croc --remember --relay "10.13.37.1:9009" blahhhhhh
