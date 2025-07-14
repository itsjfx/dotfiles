#!/usr/bin/env bash

set -eu -o pipefail

# sudo sed -E -i 's/http:\/\/(archive|security).ubuntu.com/https:\/\/mirror.gsl.icu/' /etc/apt/sources.list
sudo DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:neovim-ppa/unstable -y
sudo DEBIAN_FRONTEND=noninteractive apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
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
    bat \
    ncdu \
    moreutils \
    socat \
    python3-pip \
    magic-wormhole \

git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME"/.fzf
ln -srf "$HOME"/.fzf/bin/fzf "$HOME"/bin/
