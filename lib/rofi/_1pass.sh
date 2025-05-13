#!/usr/bin/env bash

# force tty for troubleshooting
[[ -f /dev/tty ]] && exec 2>/dev/tty
set -eu -o pipefail
set -x

# https://davatorium.github.io/rofi/1.7.3/rofi-script.5/#passing-mode-options

if (( ! ROFI_RETV )); then
    # for dodgy hotkeys
    printf '\0use-hot-keys\x1ftrue\n'
    # cache entries
    if ! [[ -f "$RUNTIME_DIR"/1password.tsv ]]; then
        op item list --vault Employee --format json --categories LOGIN | jq -r '.[] | [.id, .title, .additional_information] | @tsv' >"$RUNTIME_DIR"/1password.tsv
    fi
    while read -r id name email; do
        # display entry as: name/email but IFS plays it up
        # set icon as a lock icon
        # add the identifier as the info field, not used in search, used when looking up value from 1password when a selection is given
        printf '%s/%s\0icon\x1flock\x1finfo\x1f%s\n' "$name" "$email" "$id"
    done <"$RUNTIME_DIR"/1password.tsv
# username (custom key binding)
elif [[ "$ROFI_RETV" -eq 10 ]]; then
    # TODO pull username from additional_information
    op item get "$ROFI_INFO" --fields label=username | tr -d '\n' | xclip -selection clipboard &>/dev/null
# password
elif [[ "$ROFI_RETV" -eq 1 ]]; then
    op item get "$ROFI_INFO" --fields label=password --reveal | tr -d '\n' | xclip -selection clipboard &>/dev/null
fi
