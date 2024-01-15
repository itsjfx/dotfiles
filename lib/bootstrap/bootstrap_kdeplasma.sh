#!/usr/bin/env bash
set -eu -o pipefail


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


# needed before rebooting into new environment
# vim
# networkmanager dhclient
# sudo
# create new user with wheel group
# modify sudoers file to allow wheel group
# test sudo

# when reboot
# systemctl enable NetworkManager.service
# systemctl start NetworkManager.service
# run this script
# disable root

# for swap
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


pacman -S --noconfirm \
    sudo \
    man-db \
    nvidia \
    nvidia-utils \
    nvidia-settings \
    xorg-server \
    xf86-input-libinput \
    picom \
    xsel \
    xclip \
    xorg-xkill


pacman -S --noconfirm \
    notification-daemon \
    firefox

#pesign
#spectacle -> flameshot
pacman -S --noconfirm \
    flameshot \
    chrony \
    xdg-utils \
    lm_sensors \
    xsensors \
    dbus \
    bash-completion \
    networkmanager \
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
    smem \
    tar \
    wget \
    curl \
    man-db


pacman -S --noconfirm \
    redshift

#systemd-kcm on AUR
#sni-qt on AUR

#pinentry-qt
#qt5-qtbase-gui
#qt5-qtdeclarative
pacman -S --noconfirm \
    breeze \
    breeze-gtk \
    breeze-icons \
    dolphin \
    kde-gtk-config \
    partitionmanager \
    kdegraphics-thumbnailers \
    kdeplasma-addons \
    kdialog \
    kmenuedit \
    kscreen \
    kscreenlocker \
    ksysguard \
    kwin \
    ksystemlog \
    plasma-desktop \
    plasma-nm \
    plasma-workspace \
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

pacman -S plasma-pa

pacman -S --noconfirm \
    zram-generator

pacman -S --noconfirm \
    firewalld

systemctl enable firewalld.service | true
systemctl start firewalld.service

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
