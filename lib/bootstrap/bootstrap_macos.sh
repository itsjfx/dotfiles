#!/usr/bin/env bash

set -eu -o pipefail

# manually installing choose-gui with macos-user.sh
# nix does not add programs to /Applications/ so I install manually
# install manually via DMG (and enable auto-updates):
#   * obsidian
#   * firefox
#   * zoom/loom/slack etc (if not done already)
# for now installing alacritty with nix, not sure if it has an auto updater?
# it don't matter cause i use with a key binding anyway, doesn't need to be in Launchpad etc

# shell stuff
nix profile install \
    nixpkgs#alacritty \
    nixpkgs#bash \
    nixpkgs#ripgrep \
    nixpkgs#coreutils-full \
    nixpkgs#delta \
    nixpkgs#fd \
    nixpkgs#fnm \
    nixpkgs#fzf \
    nixpkgs#gcc \
    nixpkgs#git \
    nixpkgs#gnugrep \
    nixpkgs#gnumake \
    nixpkgs#gnused \
    nixpkgs#gawk \
    nixpkgs#yubikey-manager \
    nixpkgs#neovim \
    nixpkgs#openssh \
    nixpkgs#python3 \
    nixpkgs#skhd \
    nixpkgs#tmux \
    nixpkgs#uv \
    nixpkgs#wget \
    nixpkgs#curl \


# fonts
nix profile install \
    nixpkgs#fantasque-sans-mono \
    nixpkgs#nerd-fonts.fantasque-sans-mono \
