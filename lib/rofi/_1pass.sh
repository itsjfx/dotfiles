#!/usr/bin/env bash

[[ -f /dev/tty ]] && exec 2>/dev/tty
set -eu -o pipefail
set -x

# https://davatorium.github.io/rofi/1.7.3/rofi-script.5/#passing-mode-options

if (( ! ROFI_RETV )); then
    # for dodgy hotkeys
    printf '\0use-hot-keys\x1ftrue\n'
    while read -r id name email; do
        printf '%s/%s\0icon\x1flock\x1finfo\x1f%s\n' "$name" "$email" "$id"
    done < <(op item list --vault Employee --format json --categories LOGIN | jq -r '.[] | [.id, .title, .additional_information] | @tsv')
# username
elif [[ "$ROFI_RETV" -eq 10 ]]; then
    # TODO pull username from additional_information
    op item get "$ROFI_INFO" --fields label=username | tr -d '\n' | xclip -selection clipboard &>/dev/null
# password
elif [[ "$ROFI_RETV" -eq 1 ]]; then
    op item get "$ROFI_INFO" --fields label=password --reveal | tr -d '\n' | xclip -selection clipboard &>/dev/null
fi
