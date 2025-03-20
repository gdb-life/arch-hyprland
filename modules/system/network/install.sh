#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${MODULE_DIR}/packages.txt"
    sudo wget "https://raw.githubusercontent.com/ProtonVPN/scripts/master/update-resolv-conf.sh" -O "/etc/openvpn/update-resolv-conf"
    sudo chmod +x "/etc/openvpn/update-resolv-conf"
    mkdir $HOME/.openvpn
    cd $HOME/.openvpn
    copy_configs "${MODULE_DIR}/configs" "$HOME/.openvpn"
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${MODULE_DIR}/packages.txt"
    remove_configs "${MODULE_DIR}/configs" "$HOME/.openvpn"
fi
