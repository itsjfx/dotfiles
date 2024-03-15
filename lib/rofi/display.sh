#!/usr/bin/env bash

set -eu -o pipefail

options() {
    echo -e "Laptop Only\0icon\x1fcomputer-laptop"
    echo -e "Home\0icon\x1fakonadi-phone-home"
    echo -e "Work\0icon\x1fx-office-contact"
}

# TODO work on other machines
[[ "$(hostname)" == bazooka ]]

choice="$(options | rofi -dmenu -i -p '>' "$@")"

case "$choice" in
    "Laptop Only") xrandr --output eDP-1 --mode 1920x1200 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output DP-3 --off --output DP-4 --off ;;
    Home) xrandr --output eDP-1 --mode 1920x1200 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output DP-3 --off --output DP-4 --mode 1920x1080 --pos 1920x0 --rotate normal --refresh 240 --primary ;;
    Work) xrandr --output eDP-1 --mode 1920x1200 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output DP-4 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-3 --off;;
esac

sleep 2
nohup bash "$HOME"/lib/polybar/launch.sh >/dev/null 2>&1 &
