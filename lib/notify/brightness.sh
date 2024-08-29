#!/usr/bin/env bash

set -eu -o pipefail

NOTIFICATION_TIMEOUT=2000

brightness=''
get_brightness () {
    if [[ -z "$brightness" ]]; then
        brightness="$(brightnessctl -m -d intel_backlight | cut -d, -f4 | tr -d %)"
    fi
    echo "$brightness"
}

send_notification () {
    # brightness-low
    brightness="$(get_brightness)"
    dunstify \
    -i brightness-high \
    -t "$NOTIFICATION_TIMEOUT" \
    -h string:x-dunst-stack-tag:brightness \
    -u normal "Brightness: $brightness%" \
    -h int:value:"$brightness"
}

case "$1" in
    up)
        if [[ "$(get_brightness)" -ge 0 && "$(get_brightness)" -lt 10 ]]; then
            brightnessctl set +1%
        else
            brightnessctl set +10%
        fi
        send_notification
        ;;
    down)
        if [[ "$(get_brightness)" -le 10 ]]; then
            brightnessctl set 1%-
        else
            brightnessctl set 10%-
        fi
        send_notification
        ;;
esac
