#!/usr/bin/env bash
set -eu -o pipefail


pacman -Syy

# pip/python section

pip3 install --user --break-system-packages \
    monitorcontrol \
    cfn-flip \


# pillow for streamdeck
pacman -S --noconfirm --needed \
    python-ruamel-yaml \
    python-boto3 \
    python-pillow \
    python-websockets \
    python-pipenv \
    python-dateutil \
    python-requests \
    python-black \
    python-cfn-lint \
    python-pysocks \

pacman -S --noconfirm --needed \
    podman \
    podman-compose \
    podman-docker \
    aardvark-dns \
    slirp4netns \

# ocr
pacman -S --noconfirm --needed \
    tesseract \
    tesseract-data-eng \


# irc
# weechat
# hexchat

# android
# pacman -S --noconfirm --needed \
#     jre17-openjdk jdk17-openjdk
# yay -S android-studio

# evince or okular for a PDF reader -- trying okular

# Useful in day to day
# fuse is useful for anything that uses appimage

# not installing
# thunderbird

# fuse3 - need to look

# group with a lot of utils that help with compiling
# or shell in general
pacman -S --noconfirm --needed \
	base-devel

# mpv -> vlc
# wine-staging or wine
# yt-dlp = youtube-dl
# plasma-sdk for Cuttlefish (icon manager)
pacman -S --noconfirm --needed \
    mediainfo \
    postgresql-libs \
    ffmpeg \
    yt-dlp \
    git-delta \
    bfs \
    libnotify \
    playerctl \
    ark \
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
    magic-wormhole \
    plasma-sdk \
    reflector \
    github-cli \
    yt-dlp \
    dbeaver \
    git-filter-repo \
    speedcrunch \
    mpv \

# icons
pacman -S --noconfirm --needed \
    ttf-iosevka-nerd \
    ttf-font-awesome

# hardware hacking
pacman -S --noconfirm --needed \
    minicon \
    screen \

# streamdeck thing and yubikey
pacman -S --noconfirm --needed \
    libusb \
    hidapi \
    xf86-input-wacom \


# protobuf dev
pacman -S --noconfirm --needed \
    protobuf \


pacman -S --noconfirm --needed \
    calibre \


# yubikey
# GUI installed cos
pacman -S --noconfirm --needed \
    yubikey-manager \
    yubikey-personalization \
    libfido2 \
    yubikey-touch-detector \

systemctl --user daemon-reload
systemctl --user enable --now yubikey-touch-detector.service
# yubikey-manager-qt \
# yubikey-personalization-gui

# VNC Server
#pacman -S --noconfirm --needed \
#    x11vnc

# Early OOM daemon that runs in userspace
pacman -S --noconfirm --needed earlyoom
systemctl enable --now earlyoom

# Samba
pacman -S --noconfirm --needed \
    smbclient \
    cifs-utils

# Misc
pacman -S --noconfirm --needed \
    cowsay \
    figlet \
    neofetch \
    asciinema \


# VPN

#pacman -S --noconfirm --needed \
#    openvpn \
#    networkmanager-openvpn

pacman -S --noconfirm --needed \
    wireguard-tools

# Networking
pacman -S --noconfirm --needed \
    ngrep \
    nmap \
    wireshark-qt \
    wireshark-cli \
    inetutils \
    mitmproxy \
    gnu-netcat \
    socat \

# AWS
yay -S --noconfirm --needed aws-cli-v2 --mflags "--nocheck"

# Security

# missing bcrypt
pacman -S --noconfirm --needed \
    gnupg \
    pwgen \
    firejail \
    bubblewrap \


# DB clients
# dnf install \
#     postgresql \
#     sqlite

# Dev tools & networking tools

# not installed
# lsb
# uuid -> util-linux
# xar
pacman -S --noconfirm --needed \
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
    rustup \
    proxychains-ng \


# for python2
# install via AUR

# TODO: podman
#pacman -S --noconfirm --needed \
#    docker
#    docker-buildx

# grab from AUR
# code

# spotify
# https://aur.archlinux.org/packages/spotify/
# curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | gpg --import -

# zsh
pacman -S --noconfirm --needed \
    zsh

# discord
pacman -S --noconfirm --needed \
    discord


rustup toolchain install stable
rustup default stable

# steam
# https://wiki.archlinux.org/title/steam#Installation

# will need to install 32 bit nvidia drivers too

#pacman -S --noconfirm --needed \
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
