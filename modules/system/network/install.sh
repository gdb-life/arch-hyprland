#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"
VPN_DIR="$HOME/.openvpn"

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${MODULE_DIR}/packages.txt"

    # proton-vpn
    sudo wget "https://raw.githubusercontent.com/ProtonVPN/scripts/master/update-resolv-conf.sh" -O "/etc/openvpn/update-resolv-conf"
    sudo chmod +x "/etc/openvpn/update-resolv-conf"
    if [ ! -d $VPN_DIR ]; then
        mkdir $VPN_DIR
    fi
    copy_configs "${MODULE_DIR}/configs" "$VPN_DIR"
    read -rp "enter proton login: " LOGIN
    read -rp "enter proton password: " PASSWORD
    for file in "$VPN_DIR"/*; do
        if [ "$(basename "$file")" != "auth.txt" ]; then
            echo "auth-user-pass auth.txt" >> $file
        fi
    done
    echo "$LOGIN" >> "$VPN_DIR/auth.txt"
    echo "$PASSWORD" >> "$VPN_DIR/auth.txt"
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${MODULE_DIR}/packages.txt"
    remove_configs "${MODULE_DIR}/configs" "$VPN_DIR"
    sudo rm -rf "/etc/openvpn/update-resolv-conf"
fi
