#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"

PACKAGES=(
    zenity
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
