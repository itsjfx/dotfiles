#!/usr/bin/env bash

set -eu -o pipefail

# usage: ./apps.sh
# requires fd, gsed, gawk, choose, xargs
# https://github.com/chipsenkbeil/choose

FONT="FantasqueSansM Nerd Font Mono"
GREEN="A6E22E"
PINK="FF79C6"
# things I use daily on Mac OS
PINNED=(
    Firefox
    Finder
    Slack
    Alacritty
    zoom.us
    Loom
    'System Settings'
)

# choose opts:
#   -z search matches symbols from beginning (instead of from end by weird default)
#   -a rank early matches higher

# use awk to remove dupes *without* sorting
{
    printf '%s\n' "${PINNED[@]}"
    (
        fd '.app' '/Applications/' /System/Applications/ /System/Applications/Utilities/ /System/Library/CoreServices/ --type d -d 1 | \
        sed 's|\.app/$||' | \
        sed 's:.*/::'
    )
} | awk '!seen[$0]++' | \
    choose -a -z -f "$FONT" -c "$GREEN" -b "$PINK" | \
    xargs -I {} open -a "{}.app"
