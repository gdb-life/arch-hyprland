#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${MODULE_DIR}/packages.txt"
    copy_configs "${MODULE_DIR}/configs" "$HOME/.config/kitty"
    echo "add \"MesloLGS NF\" in vscode terminal font settings"
    # read -n 1 -s -r
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${MODULE_DIR}/packages.txt"
    remove_configs "${MODULE_DIR}/configs" "$HOME/.config/kitty"
fi
