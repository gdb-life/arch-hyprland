#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"

# Logs
source "${REP_ROOT}/scripts/logs.sh"

PACKAGES=(
    bluez
    bluez-utils
    blueman
)

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${PACKAGES[@]}"
    sudo systemctl enable --now bluetooth.service 
    log success-enabled "bluetooth.service"
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${PACKAGES[@]}"
fi
