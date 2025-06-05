#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"

PACKAGES=(
    # Mono
    ttf-meslo-nerd
    ttf-meslo-nerd-font-powerlevel10k # for zsh theme

    # Emoji
    otf-font-awesome

    # CJK
    noto-fonts-cjk 

    # MS
    ttf-ms-fonts
)

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${PACKAGES[@]}"
    fc-cache -f # forced font cache update
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${PACKAGES[@]}"
fi
