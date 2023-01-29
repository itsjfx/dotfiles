#!/usr/bin/env bash

# uses polybar colouring
# https://github.com/polybar/polybar/wiki/Formatting#foreground-color-f
# spotify font: nerdfonts
format_player() {
    case "$1" in
        spotify) echo -n "%{F#1db954} " ;;
        cmus) echo -n "%{F#06bdff}🎶 " ;;
    esac
}

for player in cmus spotify; do
    if [[ "$(playerctl status --player="$player")" == "Playing" ]]; then
        echo "$(format_player "$player")$(playerctl --player="$player" metadata --format="{{ artist }} - {{ title }}")"
        exit
    fi
done

exit 1
