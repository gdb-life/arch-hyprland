#!/bin/bash

set -e

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"

if [ "$1" == "install" ]; then
    # Connect functions
    source "${REP_ROOT}/scripts/install_packages.sh"
    source "${REP_ROOT}/scripts/install_configs.sh"
    install_packages "${MODULE_DIR}/packages.txt"
    install_configs "${MODULE_DIR}/configs" "$HOME/.config/waybar"
fi