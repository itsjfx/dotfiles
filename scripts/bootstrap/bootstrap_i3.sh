#!/usr/bin/env bash
set -eu -o pipefail


# Only root can run this script
if ! [ $UID -eq 0 ]; then
    echo 'Run this script as root' >&2
    exit 1
fi

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
        echo "Unknown platform: ${1-}. Please use desktop or laptop" >&2
        exit 2
        ;;
esac

get() { pacman -S --noconfirm --needed "$@"; }

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


# Ensure the system is up to date
pacman -Syy
pacman -Syu


cpu_arch="$(lscpu | grep '^Vendor ID:' | cut -d ':' -f2 | tr -d ' ')"
case "$cpu_arch" in
    GenuineIntel) get intel-ucode ;;
    AuthenticAMD) get amd-ucode ;;
    *) echo "Unknown CPU architecture $cpu_arch" >&2; exit 3 ;;
esac

# Remove kms from the HOOKS array in /etc/mkinitcpio.conf
# mkinitcpio -P
# reboot
(( DESKTOP )) && get \
    nvidia \
    x11vnc \
    vdpauinfo

# disable WiFi automatically
(( DESKTOP )) && nmcli radio wifi off

# laptop
# POSSIBLY need xf86-input-synaptics
# powerdevil, look at xfce alternative instead https://wiki.archlinux.org/title/Power_management#Userspace_tools
(( LAPTOP )) && get \
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

# picom -> picom-git
get \
    base-devel \
    sudo \
    man-db \
    xorg-server \
    xf86-input-libinput \
    xsel \
    xclip \
    xdotool \
    xorg-xinit \
    xorg-xinput \
    xorg-xkill \
    linux-firmware \
    openssh \


# xfce4-notifyd
get \
    dunst \
    firefox \
    chromium \


#pesign
#spectacle -> flameshot
get \
    arandr \
    hdparm \
    dos2unix \
    flameshot \
    chrony \
    ripgrep \
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
    alacritty \
    neovim \
    python \
    python-pip \
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
    btrfs-progs \
    jq \
    sysfsutils \


get \
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
get \
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
get \
    i3-wm \
    i3lock \
    polybar \
    feh \
    volumeicon \
    rofi

# missing @Fonts
get \
    fontconfig \
    ttf-dejavu \
    ttf-liberation \
    wqy-zenhei



get \
    adobe-source-han-sans-cn-fonts \
    adobe-source-han-serif-cn-fonts \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    ttf-roboto



get \
    gstreamer \
    gst-plugins-bad \
    gst-plugins-base \
    gst-plugins-good


get \
    wireplumber

# TODO: seem to always have an issue with wireplumber
# missing a bunch of pulseaudio
get \
    pipewire \
    pipewire-alsa \
    alsa-utils \
    alsa-firmware \
    pipewire-pulse \
    pavucontrol \
    pulseaudio-alsa \
    gst-plugin-pipewire

# if wanting to use zram instead of a swapfile
#get \
#    zram-generator

get \
    firewalld

# Disable sshd since the system is not yet hardened
systemctl disable sshd || true

systemctl enable NetworkManager.service
systemctl start NetworkManager.service

systemctl enable firewalld.service || true
systemctl start firewalld.service

# Set graphical target and enable sddm at boot
systemctl enable sddm.service || true
systemctl set-default graphical.target

mkdir -p ~/.ssh/
chmod 700 ~/.ssh

mkdir -p -m 700 /a/
if id jfx &>/dev/null; then
    chown -R jfx:jfx /a/
else
    echo 'No jfx user found, set the permissions for /a/ later' >&2
fi

xdg-settings set default-web-browser firefox.desktop

# Boot into the new environment
echo 'Rebooting in 10 seconds...' >&2
sleep 10
sync
reboot
