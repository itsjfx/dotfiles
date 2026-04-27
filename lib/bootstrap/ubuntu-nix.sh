#!/usr/bin/env bash

# sudo apt install -y ca-certificates
# sudo apt update -y

nix profile install \
    nixpkgs#awscli2 \
    nixpkgs#asdf-vm \
    nixpkgs#bash \
    nixpkgs#bat \
    nixpkgs#bc \
    nixpkgs#bun \
    nixpkgs#colordiff \
    nixpkgs#coreutils-full \
    nixpkgs#curl \
    nixpkgs#delta \
    nixpkgs#fd \
    nixpkgs#fnm \
    nixpkgs#fzf \
    nixpkgs#gawk \
    nixpkgs#gcc \
    nixpkgs#gettext \
    nixpkgs#git \
    nixpkgs#git-lfs \
    nixpkgs#gnugrep \
    nixpkgs#gnumake \
    nixpkgs#gnused \
    nixpkgs#gnutar \
    nixpkgs#go \
    nixpkgs#gron \
    nixpkgs#htop \
    nixpkgs#jq \
    nixpkgs#lua \
    nixpkgs#maven \
    nixpkgs#moreutils \
    nixpkgs#ncdu \
    nixpkgs#neovim \
    nixpkgs#openssh \
    nixpkgs#python3 \
    nixpkgs#readline \
    nixpkgs#ripgrep \
    nixpkgs#socat \
    nixpkgs#tmux \
    nixpkgs#tree \
    nixpkgs#unixtools.watch \
    nixpkgs#unzip \
    nixpkgs#uv \
    nixpkgs#wget \
    nixpkgs#whois \
    nixpkgs#zip \
    nixpkgs#zstd \
    nixpkgs#zsh \
    nixpkgs#postgresql \
    nixpkgs#zoxide \
    nixpkgs#mitmproxy \
    nixpkgs#gradle \
    nixpkgs#javaPackages.compiler.openjdk21 \

