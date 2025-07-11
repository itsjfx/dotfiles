#!/usr/bin/env bash

set -eu -o pipefail

# sudo sed -E -i 's/http:\/\/(archive|security).ubuntu.com/https:\/\/mirror.gsl.icu/' /etc/apt/sources.list
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt upgrade
sudo apt install \
    ca-certificates \
    neovim \
    git \
    colordiff \
    whois \
    jq \
    zstd \
    zip \
    unzip \
    bc \
    gron \
    fzf \
    bat \
    ncdu \
    moreutils \
    socat \
    python3-pip \
    magic-wormhole \

