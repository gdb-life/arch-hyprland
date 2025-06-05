#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"
HYPRLAND_SRC="${MODULE_DIR}/configs/hyprland.conf"
HYPRLAND_DEST="$HOME/.config/hypr"

# Packages categories
hyprland=(
    hyprland
    # !!! MOVE
    brightnessctl # for brightness keybinds
    playerctl # for player keybinds
)
ecosystem=(
    uwsm # Universal Wayland Session Manager
)

# Combining all categories
PACKAGES=(
    "${hyprland[@]}"
    "${ecosystem[@]}"
)

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${PACKAGES[@]}"
    copy_configs "${HYPRLAND_SRC}" "${HYPRLAND_DEST}"
    mkdir -p ~/pictures/screenshots # for screenshots
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${PACKAGES[@]}"
    remove_configs "${HYPRLAND_SRC}" "${HYPRLAND_DEST}"
fi
