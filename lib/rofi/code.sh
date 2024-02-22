#!/usr/bin/env bash

set -eu -o pipefail

dir="$HOME/.code-workspaces"
choice="$(
    (
        for file in $(find -L "$dir" -mindepth 1 -maxdepth 1 -type f -name '*.code-workspace' -print | sed "s#$dir/##" | sed 's/.code-workspace//'); do
            echo -e "$file\0icon\x1fcom.visualstudio.code"
        done
    ) | rofi -dmenu -i -p '>' "$@"
)"
code "$dir/$choice.code-workspace"
