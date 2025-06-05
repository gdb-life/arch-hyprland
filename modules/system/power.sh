#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"

PACKAGES=(
    cpupower
)

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${PACKAGES[@]}"
    sudo cpupower frequency-set --governor schedutil > /dev/null 2>&1 # sets frequency governor
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${PACKAGES[@]}"
fi
