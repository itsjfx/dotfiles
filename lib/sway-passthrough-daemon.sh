#!/usr/bin/env bash

# fork of https://raw.githubusercontent.com/b1337xyz/scripts/refs/heads/main/shell/wayland/sway-app-mode.sh

# > ~/.config/sway/config
# mode passthrough {
#         bindsym $mod+0 mode default
# }

current_mode=0

swaymsg -t subscribe -m '["window"]' |
    jq --unbuffered -r 'if .change == "focus" then .container.name // empty else empty end' |
    while read -r name; do
        case "$name" in
            *'(WayVNC) - RealVNC Viewer'*) want=1 ;;
            *) want=0 ;;
        esac
        if (( want != current_mode )); then
            (( want )) && swaymsg mode passthrough || swaymsg mode default
            current_mode="$want"
        fi
    done
