#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"

PACKAGES=(
    pipewire-alsa
    pipewire-jack
    pipewire-pulse
    lib32-pipewire
    wireplumber
)

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${PACKAGES[@]}" 
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${PACKAGES[@]}"
fi
