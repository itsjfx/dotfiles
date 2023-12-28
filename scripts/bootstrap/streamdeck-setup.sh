#!/usr/bin/env bash

if [ $UID -eq 0 ]; then
    echo "Don't run this script as root, run as the main user with sudo/wheel enabled" >&2
    exit 1
fi

sudo groupadd i2c
sudo chown :i2c /dev/i2c-*
sudo usermod -aG i2c "$USER"
