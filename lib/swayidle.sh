#!/usr/bin/env bash
case "$(hostname)" in
    sandcastle)
        # 2 hours
        exec swayidle -w \
            timeout 7200 'swaylock -f' \
            timeout 7260 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
            before-sleep 'swaylock -f'
        ;;
    *)
        # 5 mins
        exec swayidle -w \
            timeout 300 'swaylock -f' \
            timeout 330 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
            before-sleep 'swaylock -f'
        ;;
esac
