#!/usr/bin/env bash

set -eu -o pipefail

[[ "$(hostname)" == bazooka ]]

ROOT="$(realpath "$(dirname "$0")")"
# 0077 = 600 files, 700 dirs
umask 0077
session_file="${XDG_RUNTIME_DIR:-/tmp/}"/1password.sh
[[ -f "$session_file" ]] && source "$session_file"

# op account get is a pretty quick way to tell if logged in
if ! [[ -f "$session_file" ]] || ! op account get &>/dev/null; then
    pinentry-qt5 << EOF | grep -oP 'D \K.*' | op signin >"$session_file"
SETDESC Enter your 1Password master password
SETPROMPT Master Password:
GETPIN
EOF
fi

source "$session_file"
rofi -show fb -modes "fb:/$ROOT/_1pass.sh" -kb-accept-alt "Ctrl+Delete" -kb-custom-1 "Shift+Return"
