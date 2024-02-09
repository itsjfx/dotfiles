#!/usr/bin/env bash

set -eu -o pipefail

NOTIFICATION_TIMEOUT=2000
STEP=5

get_volume () {
    pamixer --get-volume-human
}

send_notification () {
    # audio-volume-high medium low muted
    volume="$(get_volume)"
    dunstify \
    -i audio-volume-high \
    -t "$NOTIFICATION_TIMEOUT" \
    -h string:x-dunst-stack-tag:volume \
    -u normal "Volume: $volume" \
    -h int:value:"$volume"
}

case "$1" in
    up)
        pamixer -i "$STEP"
        pamixer -u
        send_notification
        ;;
    down)
        pamixer -d "$STEP"
        pamixer -u
        send_notification
        ;;
esac
