#!/usr/bin/env bash

set -eu -o pipefail

case "$ROFI_RETV" in
    0)
        while read -r name description; do
            printf '%s\0icon\x1fspeaker\x1finfo\x1f%s\n' "$description" "$name"
        done < <(pactl --format=json list sinks | jq -re '.[] | [.name, .description] | @tsv')
        ;;
    1)
        pactl set-default-sink "$ROFI_INFO"
        ;;
esac
