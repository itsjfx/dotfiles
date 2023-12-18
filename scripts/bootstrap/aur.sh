#!/usr/bin/env bash

set -eu -o pipefail

if ! command -vp yay &>/dev/null; then
    (
        cd ~/.aur
        git clone https://aur.archlinux.org/yay.git || true
        cd yay
        makepkg -si
        yay -Y --gendb
    )
fi
yay -S --needed \
    alttab-git \
    cmusfm \
    fnm \
    joplin-appimage \
    picom-git \
    spotify \
    visual-studio-code-bin \
    st \
