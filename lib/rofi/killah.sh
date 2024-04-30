#!/usr/bin/env bash

set -eu -o pipefail

yesno() {
    echo -e "Yes\0icon\x1fgtk-yes"
    echo -e "No\0icon\x1fedit-none"
}

pid="$(xdotool getactivewindow getwindowpid)"
if [[ "$(xdotool getactivewindow getwindowclassname)" =~ (Alacritty|firefox) ]]; then
    confirm="$(yesno | rofi -dmenu -i -p 'Are you sure?' "$@")"
    if [[ "$confirm" == No ]]; then
        exit
    fi
fi

kill "$pid"
