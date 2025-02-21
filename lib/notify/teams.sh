#!/usr/bin/env bash

# TODO
# chromium --remote-debugging-port=9222

set -eu -o pipefail

if ! pidof chromium &>/dev/null; then
    echo 'Chromium not running' >&2
    dunstctl set-paused false
    exit 1
fi

if call="$(curl -sf http://localhost:9222/json | jq -re '.[] | select(.url == "https://teams.microsoft.com/_?culture=en-au&country=au#/modern-calling/").title')"; then
    echo "In call $call" >&2
    dunstctl set-paused true
else
    echo 'Not in a call' >&2
    dunstctl set-paused false
    exit 1
fi
