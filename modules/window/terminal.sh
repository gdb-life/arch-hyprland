#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"
KITTY_SRC="${MODULE_DIR}/configs/kitty.conf"
KITTY_DEST="$HOME/.config/kitty"

PACKAGES=(
    kitty
)

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${PACKAGES[@]}"
    copy_configs "${KITTY_SRC}" "${KITTY_DEST}"
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${PACKAGES[@]}"
    remove_configs "${KITTY_SRC}" "${KITTY_DEST}"
fi
