#!/usr/bin/env bash

set -eu -o pipefail

options() {
    echo -e "Shutdown\0icon\x1fsystem-shutdown\x1fmeta\x1fShut down"
    echo -e "Reboot\0icon\x1fsystem-reboot"
    echo -e "Sleep\0icon\x1fsystem-suspend"
    echo -e "Hibernate\0icon\x1fsystem-hibernate"
    echo -e "Lock\0icon\x1fsystem-lock-screen-symbolic"
    # echo -e "Lock\0icon\x1fsystem-lock-screen"
    echo -e "Logout\0icon\x1fsystem-log-out\x1fmeta\x1fLog out"
}

yesno() {
    echo -e "Yes\0icon\x1fgtk-yes"
    echo -e "No\0icon\x1fedit-none"
}

choice="$(options | rofi -dmenu -i -p '>' "$@")"

if [[ "$choice" == Shutdown || "$choice" == Reboot || "$choice" == Logout ]]; then
    confirm="$(yesno | rofi -dmenu -i -p 'Are you sure?' "$@")"
    if [[ "$confirm" == No ]]; then
        exit 1
    fi
fi

case "$choice" in
    Shutdown) systemctl poweroff ;;
    Reboot) systemctl reboot ;;
    Sleep) systemctl suspend ;;
    Hibernate) systemctl hibernate ;;
    Lock) loginctl lock-session "${XDG_SESSION_ID-}" ;;
    Logout) i3-msg exit ;;
    *) exit 2 ;;
#    Logout) loginctl terminate-session "${XDG_SESSION_ID-}" ;;
esac
