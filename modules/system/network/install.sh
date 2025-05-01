#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"
PACKAGES="${MODULE_DIR}/packages.txt"
SRC_CONFIGS="${MODULE_DIR}/configs"
DEST_CONFIGS="$HOME/.openvpn"

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${PACKAGES}"

    # proton-vpn
    sudo wget "https://raw.githubusercontent.com/ProtonVPN/scripts/master/update-resolv-conf.sh" -O "/etc/openvpn/update-resolv-conf"
    sudo chmod +x "/etc/openvpn/update-resolv-conf"
    if [ ! -d $DEST_CONFIGS ]; then
        mkdir $DEST_CONFIGS
    fi
    copy_configs "${SRC_CONFIGS}" "${DEST_CONFIGS}"
    read -rp "enter proton login: " LOGIN
    read -rp "enter proton password: " PASSWORD
    for file in "$DEST_CONFIGS"/*; do
        if [ "$(basename "$file")" != "auth.txt" ]; then
            echo "auth-user-pass auth.txt" >> $file
        fi
    done
    echo "$LOGIN" >> "$DEST_CONFIGS/auth.txt"
    echo "$PASSWORD" >> "$DEST_CONFIGS/auth.txt"
    sudo chmod 600 "$DEST_CONFIGS/auth.txt"
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${PACKAGES}"
    remove_configs "${SRC_CONFIGS}" "${DEST_CONFIGS}"
    sudo rm -rf "/etc/openvpn/update-resolv-conf"
fi
