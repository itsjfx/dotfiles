#!/usr/bin/env bash

set -eu -o pipefail

if [[ ! -f /etc/arch-release ]]; then
    echo 'Not running on Arch. Exitting' >&2
    exit 1
fi

if ! command -vp yay &>/dev/null; then
    (
        echo 'Doing initial install of yay' >&2
        cd "$(mktemp -d)"
        git clone https://aur.archlinux.org/yay.git || true
        cd yay
        makepkg -si
        yay -Y --gendb
    )
fi
# winbox if wine is installed TODO
yay -S --needed \
    alttab \
    cmusfm \
    fnm \
    joplin-appimage \
    picom-git \
    spotify \
    visual-studio-code-bin \
    st \
    asciinema-agg \
    realvnc-vnc-viewer \
    pandoc-bin \
    isoimagewriter \
    cmus-git \
    claude-code \
    sway-alttab-gui-bin \

