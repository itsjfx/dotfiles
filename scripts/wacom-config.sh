#!/usr/bin/env bash

set -eu -o pipefail

for i in $(seq 10); do
    if xsetwacom list devices | command grep -q Wacom; then
        break
    fi
    sleep 1
done
if ! xsetwacom list devices | command grep -q Wacom; then
    exit 1
fi
# this is really shit but it does the job
stylus="$(xsetwacom list devices | command grep stylus | cut -f1 | awk '{$1=$1;print}')"

echo "Mapping stylus: $stylus to monitor: HEAD-0" >&2
# really shit way to figure out if nvidia
# and im just assuming HEAD-0
if builtin command -v nvidia-settings &>/dev/null; then
    monitor='HEAD-0'
else
    monitor="$(xrandr | awk '/ primary / {print $1}')"
fi
xsetwacom set "$stylus" MapToOutput "$monitor"
