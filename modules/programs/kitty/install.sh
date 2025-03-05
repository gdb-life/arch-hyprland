#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"

if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${MODULE_DIR}/packages.txt"
    copy_configs "${MODULE_DIR}/configs" "$HOME/.config/kitty"
fi

if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${MODULE_DIR}/packages.txt"
    remove_configs "${MODULE_DIR}/configs" "$HOME/.config/kitty"
fi
