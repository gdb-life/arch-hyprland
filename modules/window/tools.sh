#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"

PACKAGES=(
    slurp   # for screenshots
    grim    # for screenshots
    wl-clipboard    # for screenshots and buffer
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
