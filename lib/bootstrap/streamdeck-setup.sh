#!/usr/bin/env bash

if [ $UID -eq 0 ]; then
    echo "Don't run this script as root, run as the main user with sudo/wheel enabled" >&2
    exit 1
fi

pip3 install --user --break-system-packages \
    streamdeck \
    pulsectl \


sudo groupadd i2c
sudo chown :i2c /dev/i2c-*
sudo usermod -aG i2c "$USER"
