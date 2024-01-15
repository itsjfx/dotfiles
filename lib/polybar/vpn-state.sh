#!/usr/bin/env bash

set -eu -o pipefail

check() {
    nmcli -f GENERAL.STATE con show "$1" 2>/dev/null | grep -qs 'activated$';
}

if check wg0; then
    #printf '%s' '%{F#06bdff}wg0'
    printf '%s' '%{F#1db954}wg0'
    #printf '%s' '%{F#FF0000}wg0'
else
    printf '%s' '%{F#FF0000}wg0'
fi

