#!/usr/bin/env bash

# uses polybar colouring
# https://github.com/polybar/polybar/wiki/Formatting#foreground-color-f
# spotify font: nerdfonts
format_player() {
    case "$1" in
        spotify) echo -n "%{F#1db954} " ;;
        cmus) echo -n "%{F#06bdff}🎶 " ;;
    esac
    playerctl --player="$1" metadata --format="{{ artist }} - {{ title }}"
}

for player in cmus spotify; do
    if [[ "$(playerctl status --player="$player")" == "Playing" ]]; then
        format_player "$player"
        exit
    fi
done

exit 1
