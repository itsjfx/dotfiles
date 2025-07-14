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

git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME"/.fzf
ln -srf "$HOME"/.fzf/bin/fzf "$HOME"/bin/

pip install uv

curl -L "$(curl -sSL "https://api.github.com/repos/dandavison/delta/releases/latest" | jq -r '.assets[] | select(.browser_download_url | endswith("amd64.deb")).browser_download_url' | grep -v musl)" -o /tmp/delta.deb

sudo dpkg -i /tmp/delta.deb
