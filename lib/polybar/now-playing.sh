#!/usr/bin/env bash

# uses polybar colouring
# https://github.com/polybar/polybar/wiki/Formatting#foreground-color-f
# spotify font: nerdfonts
format_player() {
    case "$1" in
        spotify) echo -n "%{F#50fa7b} " ;; # green
        cmus) echo -n "%{F#06bdff}🎶 " ;;   # blue-ish
    esac
    text="$(playerctl --player="$1" metadata --format="{{ artist }} - {{ title }}")"
    printf '%s' "${text:0:68}"
}

for player in cmus spotify; do
    if [[ "$(playerctl status --player="$player" 2>/dev/null)" == "Playing" ]]; then
        format_player "$player"
        exit
    fi
done

exit 1
