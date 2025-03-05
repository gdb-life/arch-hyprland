#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${MODULE_DIR}/packages.txt"
    sudo systemctl enable sddm
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    sudo systemctl disable sddm
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${MODULE_DIR}/packages.txt"
fi
