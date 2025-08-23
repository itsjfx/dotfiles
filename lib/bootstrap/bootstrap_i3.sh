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
        echo "Unknown platform: ${1-}. Please use desktop or laptop" >&2
        exit 2
        ;;
esac

get() { sudo pacman -S --noconfirm --needed "$@"; }

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
sudo pacman -Syy
sudo pacman -Syu


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
    nvidia-open \
    libva-nvidia-driver \
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
    blueman \
    acpi \
    intel-gpu-tools \
    powertop \
    tlp \


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
    chrony \
    ffmpeg \


# xfce4-notifyd
get \
    dunst \
    firefox \
    chromium \


#pesign
#spectacle -> flameshot -> spectacle
get \
    arandr \
    hdparm \
    dos2unix \
    spectacle \
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
    zstd \
    zip \
    brightnessctl \
    dosfstools \
    arch-install-scripts \
    man-pages \
    fd \
    usbutils \



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
    qt5ct \
    xdg-desktop-portal \
    xdg-desktop-portal-kde \


# i3

#i3status now polybar
get \
    i3-wm \
    i3lock \
    polybar \
    feh \
    volumeicon \
    rofi \
    xss-lock \

# missing @Fonts
get \
    fontconfig \
    ttf-dejavu \
    ttf-liberation \
    wqy-zenhei \
    ttf-fantasque-sans-mono \
    ttf-fantasque-nerd



get \
    adobe-source-han-sans-cn-fonts \
    adobe-source-han-serif-cn-fonts \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    ttf-roboto



get \
    gstreamer \
    gst-libav \
    gst-plugins-bad \
    gst-plugins-base \
    gst-plugins-good


# TODO: seem to always have an issue with wireplumber
# missing a bunch of pulseaudio
    #alsa-utils \
    #alsa-firmware \
get \
    pipewire \
    pipewire-audio \
    pipewire-alsa \
    pipewire-pulse \
    wireplumber \
    pavucontrol \
    sof-firmware \
    gst-plugin-pipewire \
    pamixer \

# if wanting to use zram instead of a swapfile
#get \
#    zram-generator

get \
    firewalld

# Disable sshd since the system is not yet hardened
sudo systemctl disable sshd || true

sudo systemctl --now enable NetworkManager.service
sudo systemctl --now enable firewalld.service || true
sudo systemctl --now enable chronyd.service

# Set graphical target and enable sddm at boot
sudo systemctl --now enable sddm.service || true
sudo systemctl set-default graphical.target

mkdir -p -m 700 "$HOME"/.ssh/
sudo mkdir -p -m 700 /a/
sudo chown -R "$USER":"$USER" /a/

# https://wiki.archlinux.org/title/TLP
if (( LAPTOP )); then
    sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
    sudo systemctl --now enable tlp.service
fi

if (( DESKTOP )); then
    sudo systemctl enable nvidia-hibernate.service
    sudo systemctl enable nvidia-suspend.service
    sudo systemctl enable nvidia-resume.service
fi

sudo systemctl enable systemd-boot-update.service
sudo systemctl enable paccache.timer

# Boot into the new environment
echo 'Rebooting in 10 seconds...' >&2
sleep 10
sync
reboot
