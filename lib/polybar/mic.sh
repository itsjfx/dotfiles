#!/usr/bin/env bash

set -eu -o pipefail

volume="$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | sed 's/Volume: //' | awk '{ printf "%.0f\n", $1 * 100 }')"
if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q yes$; then
    echo -n "%{F#707880}󰍭 $volume%"
else
    printf '󰍬 %s' "$volume"%
fi
