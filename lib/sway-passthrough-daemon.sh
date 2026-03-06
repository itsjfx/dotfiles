#!/usr/bin/env bash

# fork of https://raw.githubusercontent.com/b1337xyz/scripts/refs/heads/main/shell/wayland/sway-app-mode.sh

# > ~/.config/sway/config
# mode passthrough {
#         bindsym $mod+0 mode default
# }

swaymsg -t subscribe -m '["window"]' | while read -r line; do
    if name="$(<<<"$line" jq -re 'if .change == "focus" then .container.name else null end')"; then
        case "$name" in
            *'(WayVNC) - RealVNC Viewer'*) swaymsg mode passthrough ;;
            *) swaymsg mode default ;;
        esac
    fi
done
