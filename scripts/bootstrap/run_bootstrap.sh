#!/usr/bin/env bash

set -eu -o pipefail

if [ $UID -eq 0 ]; then
    echo "Don't run this script as root, run as the main user with sudo/wheel enabled" >&2
    exit 1
fi

echo "Running as $USER" >&2

cd "$HOME"
rm -f .bashrc
git init --bare ~/.dotfiles

config() { /usr/bin/git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME" "$@"; }

config remote add origin https://github.com/itsjfx/dotfiles.git || true
echo "Don't forget to change origin ref to SSH later" >&2

config config status.showUntrackedFiles no
config pull origin master

sudo bash ~/scripts/bootstrap.sh
