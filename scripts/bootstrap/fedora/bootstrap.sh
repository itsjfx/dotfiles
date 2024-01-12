#!/usr/bin/env bash
set -eu -o pipefail

# rpm fusion install
# intel-media-driver

# Only root can run this script
[ $UID -eq 0 ] || exit 1

# Ensure the system is up to date
dnf update -y --refresh

# X server and drivers
dnf -y install \
    glx-utils \
    mesa-dri-drivers \
    mesa-vulkan-drivers \
    plymouth-system-theme \
    xorg-x11-drv-evdev \
    xorg-x11-drv-fbdev \
    xorg-x11-drv-intel \
    xorg-x11-drv-libinput \
    xorg-x11-drv-vesa \
    xorg-x11-server-Xorg \
    xorg-x11-server-utils \
    xorg-x11-utils \
    xorg-x11-xauth \
    xorg-x11-xinit \
    xbacklight \
    picom \
    xsel \
    xclip \
    xkill

# Wireless drivers (the 7260 package contains firmwares for many other Intel cards too)
dnf -y install \
    iwl7260-firmware \
    linux-firmware

# Printing
#    kde-print-manager \
#    cups-pk-helper \

# Desktop
dnf -y install \
    notification-daemon \
    firefox

#gnome-disk-utility
#gnome-logs
#gnome-keyring-pam

#udiskie

# System tools
# NetworkManager-tui is not needed alongside the Plasma UI but it's nice to have
# for terminal emulator replace kitty with something else
# e.g. alacritty konsole gnome-terminal
dnf -y install \
    dnf-plugins-core \
    spectacle \
    chrony \
    xdg-utils \
    lm_sensors \
    xsensors \
    dbus-x11 \
    bash-completion \
    NetworkManager-tui \
    NetworkManager-wifi \
    net-tools \
    wireless-tools \
    bind-utils \
    git \
    tmux \
    kitty \
    neovim \
    python3-neovim \
    nano \
    whois \
    traceroute \
    unzip \
    bzip2 \
    p7zip \
    ntfs-3g \
    readline \
    tree \
    htop \
    rsync \
    colordiff \
    mtr \
    psmisc \
    words \
    ranger \
    smem \
    dnf-utils \
    pesign \
    tar \
    wget \
    curl

# KDE
# kde-partitionmanager instead of gparted
dnf -y install \
    bluedevil \
    powerdevil \
    breeze-gtk \
    breeze-icon-theme \
    dolphin \
    kcm_systemd \
    kde-gtk-config \
    kde-partitionmanager \
    kde-style-breeze \
    kdegraphics-thumbnailers \
    kdeplasma-addons \
    kdialog \
    kmenuedit \
    kscreen \
    kscreenlocker \
    ksysguard \
    kwin-x11 \
    ksystemlog \
    pinentry-qt \
    plasma-breeze \
    plasma-desktop \
    plasma-desktop-doc \
    plasma-nm \
    plasma-pa \
    plasma-user-manager \
    plasma-workspace-x11 \
    polkit-kde \
    qt5-qtbase-gui \
    qt5-qtdeclarative \
    sddm \
    sddm-breeze \
    sddm-kcm \
    libappindicator \
    colord-kde \
    kcalc \
    gwenview \
    sni-qt

# Fonts
dnf -y install \
    @"Fonts" \
    fontconfig \
    dejavu-sans-fonts \
    dejavu-sans-mono-fonts \
    dejavu-serif-fonts \
    liberation-mono-fonts \
    liberation-sans-fonts \
    liberation-serif-fonts

# Optional Fonts for Asian languages (you'll encounter ugliness in browsers without these)
dnf -y install \
    adobe-source-han-sans-cn-fonts \
    adobe-source-han-serif-cn-fonts \
    google-noto-sans-thai-fonts \
    google-noto-serif-thai-fonts \
    un-core-batang-fonts

# Codecs
dnf -y install \
    gstreamer1 \
    gstreamer1-plugins-bad-free \
    gstreamer1-plugins-bad-free-gtk \
    gstreamer1-plugins-base \
    gstreamer1-plugins-good

# Sound
dnf -y install \
    pulseaudio-libs \
    pulseaudio-utils \
    kde-settings-pulseaudio \
    alsa-plugins-pulseaudio \
    alsa-utils \
    pavucontrol \
    pipewire-pulseaudio \
    alsa-sof-firmware

# Install h264
dnf -y install \
    gstreamer1-plugin-openh264

# ZRAM for Swap
dnf -y install \
    zram-generator \
    zram-generator-defaults

# Set graphical target and enable lightdm at boot
systemctl enable sddm.service | true
systemctl set-default graphical.target

# Disable sshd since the system is not yet hardened
# shellcheck disable=SC2216
systemctl disable sshd | true

# Boot into the new environment
echo 'Rebooting in 10 seconds...'
sleep 10
sync
reboot
