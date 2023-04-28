#!/usr/bin/env bash

set -eu -o pipefail

# i don't use an AUR manager so some ghetto shit
# TODO: look into yay ?

mkdir -p ~/aur/

for package in "alttab-git" "cmusfm" "fnm" "joplin-appimage" "picom-git" "spotify-snapstore" "visual-studio-code-bin" "st"; do
    git clone https://aur.archlinux.org/"$package".git "$HOME"/aur/"$package"
done
