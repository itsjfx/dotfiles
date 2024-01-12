#!/usr/bin/env bash
set -eu -o pipefail

# evince or okular for a PDF reader -- trying okular

# Useful in day to day
# fuse is useful for anything that uses appimage
# find that chromium is useful on certain websites compared to firefox
dnf install \
    jq \
    bc \
    gimp \
    libreoffice \
    thunderbird \
    okular \
    fzf \
    bat \
    firejail \
    keepassx \
    freerdp \
    perl-Image-ExifTool \
    openssl \
    fuse \
    pciutils \
    chromium \
    ncdu \
    moreutils \
    ark \
    yamllint

# Early OOM daemon that runs in userspace
dnf install earlyoom
systemctl enable --now earlyoom

# Samba
dnf install \
    samba-client \
    cifs-utils

# Misc
dnf install \
    cowsay \
    figlet \
    neofetch

# VPN
dnf install \
    openvpn \
    NetworkManager-openvpn \
    plasma-nm-openvpn \
    wireguard-tools

# SELinux
dnf install \
    setools \
    setroubleshoot \
    setroubleshoot-plugins \
    setroubleshoot-server

# Networking
dnf install \
    ngrep \
    nmap \
    nmap-ncat \
    wireshark \
    telnet

# Security
dnf install \
    gnupg \
    gnupg2 \
    pwgen \
    bcrypt

# DB clients
dnf install \
    postgresql \
    sqlite

# Dev tools & networking tools
dnf install \
    binutils \
    cmake \
    gcc \
    gdb \
    glibc-devel \
    glibc-headers \
    lsb \
    lsof \
    ltrace \
    make \
    psmisc \
    ruby \
    ruby-devel \
    ShellCheck \
    strace \
    uuid \
    valgrind \
    xar \
    pylint \
    python \
    python-devel \
    python-pip \
    python-virtualenv

# proxychains
# install from https://github.com/rofl0r/proxychains-ng

# point python to python 2.7 instead of python 3
rm /usr/bin/python
ln -s /usr/bin/python2.7 /usr/bin/python

# https://docs.docker.com/engine/install/fedora/
dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo

dnf install \
    docker-ce \
    docker-ce-cli \
    containerd.io

# https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

dnf check-update
dnf install code

# vnc viewer
# https://www.realvnc.com/en/connect/download/viewer/linux/
# install with sudo rpm -U VNC.rpm

# zsh
dnf install zsh

# needed by slack
dnf install libappindicator-gtk3
# download slack
# https://slack.com/intl/en-au/downloads/instructions/fedora
# install with sudo RPM -U slack.rpm

# download teams
# https://www.microsoft.com/en-au/microsoft-teams/download-app
#
# if using teams and having issues with sound (speakers not being detected during calls)
# edit /usr/share/pipewire/media-session.d/alsa-monitor.conf
# uncomment #audio.format = "S16LE"
# restart teams / pipewire


# mouse accel
# https://wiki.archlinux.org/title/Mouse_acceleration#Disabling_mouse_acceleration
#/etc/X11/xorg.conf.d/50-mouse-acceleration.conf

#Section "InputClass"
#	Identifier "My Mouse"
#	MatchIsPointer "yes"
#	Option "AccelerationProfile" "-1"
#	Option "AccelerationScheme" "none"
#	Option "AccelSpeed" "-1"
#EndSection


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


# The following are also good, but come from rpmfusion, install it if you want them
# https://rpmfusion.org/Configuration (be sure to verify GPG signatures)
# mpv
# obs-studio
# exfat-utils
# fuse-exfat
# unrar
# cmus

# wireshark-gtk # dead ?
