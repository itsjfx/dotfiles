#!/usr/bin/env bash

set -eu -o pipefail
set -x

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
