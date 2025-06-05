#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"
PROTON_SRC="${MODULE_DIR}/assets/protonvpn"
PROTON_USER_DEST="$HOME/.openvpn"
PROTON_CONF_DEST="/etc/openvpn/update-resolv-conf"

PACKAGES=(
    networkmanager
    networkmanager-strongswan   # for vpn IKEv2/IPsec support
    openssh
    openvpn
    openresolv
    wget    # for zsh installation
)

# Logs
source "${REP_ROOT}/scripts/logs.sh"

# Install
if [ "$1" == "install" ]; then

    # Check internet connection
    if ! ping -q -c 1 -W 1 1.1.1.1 >/dev/null; then
        log error "no internet connection"
        exit 1
    fi

    # Install packages
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${PACKAGES}"

    # NetworkManager
    sudo systemctl enable --now NetworkManager.service
    log success-enabled "NetworkManager.service"



    # ProtonVPN

    log info-installing "ProtonVPN..."

    # Get proton config
    sudo mkdir -p "$(dirname "$PROTON_CONF_DEST")"
    if sudo wget -q "https://raw.githubusercontent.com/ProtonVPN/scripts/master/update-resolv-conf.sh" -O "$PROTON_CONF_DEST"; then
        sudo chmod +x "$PROTON_CONF_DEST"
        log success-created "'$PROTON_CONF_DEST'"
    else
        log error "failed to download update-resolv-conf.sh"
        exit 1
    fi

    # Create user dir for proton .ovpn files
    mkdir -p "$PROTON_USER_DEST"
    copy_configs "${PROTON_SRC}" "${PROTON_USER_DEST}"

    log warning "for proton vpn to work, user credentials must be specified in each .ovpn files"
    if ask_yes_no "Do you want to add your ProtonVPN credentials now?" no; then
        read -rp "enter proton login: " LOGIN
        read -rp "enter proton password: " PASSWORD
        for file in "$PROTON_USER_DEST"/*; do
            if grep -q "^auth-user-pass$" "$file"; then
                sed -i 's/^auth-user-pass$/auth-user-pass auth.txt/' "$file"
            elif ! grep -q "auth-user-pass auth.txt" "$file"; then
                echo "auth-user-pass auth.txt" >> "$file"
            fi
        done
        {
            echo "$LOGIN"
            echo "$PASSWORD"
        } > "$PROTON_USER_DEST/auth.txt"
        chmod 600 "$PROTON_USER_DEST/auth.txt"
    else
        log info "skipping ProtonVPN credential setup"
    fi
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${PACKAGES}"
    remove_configs "${PROTON_SRC}" "${PROTON_USER_DEST}"
    sudo rm -rf "$PROTON_CONF_DEST"
fi
