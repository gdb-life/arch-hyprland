#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"
PACKAGES="${MODULE_DIR}/packages.txt"
SRC_CONFIGS="${MODULE_DIR}/configs"
DEST_CONFIGS="$HOME/.config/hypr"

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${PACKAGES}"
    copy_configs "${SRC_CONFIGS}" "${DEST_CONFIGS}"
    mkdir -p ~/pictures/screenshots
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${PACKAGES}"
    remove_configs "${SRC_CONFIGS}" "${DEST_CONFIGS}"
fi
