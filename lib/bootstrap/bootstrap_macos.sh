#!/usr/bin/env bash

set -eu -o pipefail
set -x

# manually installing choose-gui with macos-user.sh
# nix does not add programs to /Applications/ so I install manually
# install manually via DMG (and enable auto-updates):
#   * obsidian
#   * firefox
#   * zoom/loom/slack etc (if not done already)
# for now installing alacritty with nix, not sure if it has an auto updater?
# it don't matter cause i use with a key binding anyway, doesn't need to be in Launchpad etc

# general shell stuff
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
    nixpkgs#bun \
    nixpkgs#htop \
    nixpkgs#unixtools.watch \
    nixpkgs#awscli2 \
    nixpkgs#nerd-fonts.noto \
    nixpkgs#ncdu \
    nixpkgs#nerd-fonts.dejavu-sans-mono \
    nixpkgs#lua \
    nixpkgs#readline \
    nixpkgs#tree \
    nixpkgs#moreutils \
    nixpkgs#gnutar \
    nixpkgs#socat \

# extras
nix profile install \
    nixpkgs#cmus \
    nixpkgs#yt-dlp \


# podman
# nix profile install \
#     nixpkgs#podman \
#     nixpkgs#podman-compose \


# work specific
nix profile install \
    nixpkgs#maven \
    nixpkgs#go \
    nixpkgs#gettext \
    nixpkgs#git-lfs \


# fonts
nix profile install \
    nixpkgs#fantasque-sans-mono \
    nixpkgs#nerd-fonts.fantasque-sans-mono \

# latest not in nix
brew install asdf
asdf completion zsh > "$HOME"/.completions/_asdf

# not in nix
brew install displayplacer

brew install --cask nikitabobko/tap/aerospace
brew tap FelixKratz/formulae
brew install sketchybar

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

# https://keith.github.io/xcode-man-pages/synthetic.conf.5.html
# just like in the Linux bootstrap, create a folder called /a/ for putting stuff into
if ! [ -d /a/ ]; then
    echo "TODO: Make /a/ in sythentics.conf file" >&2
    # a       /Users/USERNAME/.a
fi
mkdir -p "$HOME"/.a/

# make a firefox folder like on Linux
# so my other scripts to copy profile files and my brain works
ln -sf "$HOME/Library/Application Support/Firefox/Profiles" ~/.mozilla/firefox

#
# most of below from: https://github.com/todd-dsm/mac-ops/blob/main/bootstrap.sh
#

# default Finder searches to current dir
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# new windows go to HOME DIR
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# screenshots
mkdir -p "$SCREENSHOT_DIR"
defaults write com.apple.screencapture location "$SCREENSHOT_DIR"

# To prevent startup when opening the lid or connecting to power
# https://support.apple.com/en-au/120622
sudo nvram BootPreference=%00

# you can move windows by holding ctrl+cmd and dragging any part of the window (not necessarily the window title)
# https://github.com/nikitabobko/AeroSpace?tab=readme-ov-file#tip-of-the-day
defaults write -g NSWindowShouldDragOnGesture -bool true
