#!/usr/bin/env bash

# https://www.reddit.com/r/qtools/comments/dwadrk/rofiquestion_how_to_use_icons_in_scripts/f7l99ud/
# https://github.com/davatorium/rofi/blob/a53daa68c4298fc64b17ea613705081c42c140c5/Examples/test_script_mode.sh#L24
choice="$(awk -F "=" '/Name/ { output=$2"\0icon\x1ffirefox"; print output }' "$HOME"/.mozilla/firefox/profiles.ini | sort | rofi -dmenu -i -p '>' "$@")"
if [[ -n "$choice" ]]; then
    firefox -P "$choice" &
fi
