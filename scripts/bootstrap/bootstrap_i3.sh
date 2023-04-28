#!/usr/bin/env bash
set -eu -o pipefail

LAPTOP=0
DESKTOP=0
case "${1:-}" in
    desktop)
        echo 'Using desktop packages' >&2
        DESKTOP=1 ;;
    laptop)
        echo 'Using laptop packages' >&2
        LAPTOP=1
        ;;
    *)
        echo "Unknown: ${1:-}" >&2
        exit 1
        ;;
esac

# https://wiki.archlinux.org/title/installation_guide
# https://itsfoss.com/install-arch-linux/

# grub
# pacman -S grub efibootmgr
# mkdir /efi
# mount /dev/sda1 OR efi vol /efi
# grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/efi
#
# for dual boot:
# pacman -S os-prober
# echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub
#
# grub-mkconfig -o /boot/grub/grub.cfg

# KERNEL
# pacstrap
# linux for stable
# linux-lts for LTS

# needed before rebooting into new environment
# INSTALL: vim networkmanager dhclient sudo
# create new user with wheel group
# modify sudoers file to allow wheel group
# test sudo

# when reboot
# systemctl enable NetworkManager.service
# systemctl start NetworkManager.service
# run this script
# disable root

# for swap with zram
# add 
# /etc/systemd/zram-generator.conf
# /etc/fstab add
# /dev/zram0 none swap defaults 0 0

# for hibrenate swap file
# sudo fallocate -l 8G /swapfile
# needs to be bigger than
# cat /sys/power/image_size
# chmod 600 /swapfile
# mkswap /swapfile
# sudo swapon /swapfile -p '-2'
# in /etc/fstab


# Only root can run this script
[ $UID -eq 0 ] || exit 1

# Ensure the system is up to date
pacman -Syu
pacman -Syy


# intel cpu
pacman -S --noconfirm \
    intel-ucode

# Remove kms from the HOOKS array in /etc/mkinitcpio.conf
# mkinitcpio -P
# reboot
(( DESKTOP )) && pacman -S --noconfirm \
    nvidia \
    x11vnc \
    vdpauinfo

# laptop
# POSSIBLY need xf86-input-synaptics
# powerdevil, look at xfce alternative instead https://wiki.archlinux.org/title/Power_management#Userspace_tools
(( LAPTOP )) && pacman -S --noconfirm \
    mesa \
    vulkan-intel \
    intel-media-driver \
    iw \
    wpa_supplicant \
    bluez \
    bluez-utils \
    libva-utils \
    light \
    blueman \
    acpi

pacman -S --noconfirm \
    base-devel \
    sudo \
    man-db \
    xorg-server \
    xf86-input-libinput \
    xsel \
    xclip \
    xorg-xinit \
    xorg-xinput \
    xorg-xkill \
    linux-firmware \
    openssh \
    picom


# xfce4-notifyd
pacman -S --noconfirm \
    dunst \
    firefox

#pesign
#spectacle -> flameshot
pacman -S --noconfirm \
    arandr \
    hdparm \
    dos2unix \
    flameshot \
    chrony \
    xdg-utils \
    lm_sensors \
    xsensors \
    dbus \
    bash-completion \
    networkmanager \
    nm-connection-editor \
    network-manager-applet \
    dhclient \
    net-tools \
    bind \
    git \
    tmux \
    kitty \
    neovim \
    python-neovim \
    nano \
    whois \
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
    tar \
    wget \
    curl \
    man-db \
    btrfs-progs


pacman -S --noconfirm \
    redshift

#systemd-kcm on AUR
#sni-qt on AUR

#pinentry-qt
#qt5-qtbase-gui
#qt5-qtdeclarative
#kde-gtk-config
#kdeplasma-addons
#kscreen
#kscreenlocker
#kwin
# plasma-desktop \
# plasma-nm \
# plasma-workspace \
pacman -S --noconfirm \
    breeze \
    breeze-gtk \
    breeze-icons \
    dolphin \
    partitionmanager \
    kdegraphics-thumbnailers \
    kdialog \
    kmenuedit \
    ksysguard \
    ksystemlog \
    polkit-kde-agent \
    sddm \
    sddm-kcm \
    libappindicator-gtk3 \
    colord-kde \
    kcalc \
    qt5-base \
    qt5-declarative \
    kcolorchooser \
    gwenview \
    qt5ct


# i3

#i3status now polybar
pacman -S --noconfirm \
    i3-wm \
    i3lock \
    polybar \
    feh \
    volumeicon \
    rofi

# missing @Fonts
pacman -S --noconfirm \
    fontconfig \
    ttf-dejavu \
    ttf-liberation \
    wqy-zenhei



pacman -S --noconfirm \
    adobe-source-han-sans-cn-fonts \
    adobe-source-han-serif-cn-fonts \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    ttf-roboto



pacman -S --noconfirm \
    gstreamer \
    gst-plugins-bad \
    gst-plugins-base \
    gst-plugins-good


pacman -S --noconfirm \
    wireplumber

# TODO: seem to always have an issue with wireplumber
# missing a bunch of pulseaudio
pacman -S --noconfirm \
    pipewire \
    pipewire-alsa \
    alsa-utils \
    alsa-firmware \
    pipewire-pulse \
    pavucontrol \
    pulseaudio-alsa \
    gst-plugin-pipewire

# if wanting to use zram instead of a swapfile
#pacman -S --noconfirm \
#    zram-generator

pacman -S --noconfirm \
    firewalld

# Disable sshd since the system is not yet hardened
# shellcheck disable=SC2216
systemctl disable sshd || true

systemctl enable NetworkManager.service
systemctl start NetworkManager.service

systemctl enable firewalld.service || true
systemctl start firewalld.service

# Set graphical target and enable sddm at boot
systemctl enable sddm.service || true
systemctl set-default graphical.target

# Boot into the new environment
echo 'Rebooting in 10 seconds...' >&2
sleep 10
sync
reboot
