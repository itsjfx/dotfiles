#!/usr/bin/env bash

set -eu -o pipefail

NOTIFICATION_TIMEOUT=2000

get_brightness () {
    brightnessctl -m -d intel_backlight | cut -d, -f4 | tr -d %
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
        brightnessctl set +10%
        send_notification
        ;;
    down)
        brightnessctl set 10%-
        send_notification
        ;;
esac
