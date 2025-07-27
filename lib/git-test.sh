#!/usr/bin/env bash

# https://git-scm.com/docs/git-config#Documentation/git-config.txt-gpgsshdefaultKeyCommand

[ -e /dev/tty ] && exec 2>/dev/tty


# host="$(git remote get-url origin | sed 's/.*@//' | sed 's/:.*//')"
# echo "$host" >&2
if [ -n "$SSH_CLIENT" ]; then
    if match="$(ssh-add -L | grep -m 1 -e bazooka -e rpg)"; then
        :
    elif ! match="$(ssh-add -L | grep -m 1 'github@keychain')"; then
        echo "Could not find keychain key in SSH Agent" >&2
        exit 1
    fi
else
    if ! match="$(ssh-add -L | grep -m 1 -E "github@$(hostname)$")"; then
        echo "Could not find key in SSH Agent" >&2
        exit 1
    fi
fi
echo "Signing with key: $(echo "$match" | cut -f3 -d ' ')" >&2
echo "key::$match"
