#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"
PACKAGES="${MODULE_DIR}/packages.txt"
CONFIG_DIR="/etc/sddm.conf.d"
CONFIG_FILE="${CONFIG_DIR}/autologin.conf"

# Logs
source "${REP_ROOT}/scripts/logs.sh"

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${PACKAGES}"
    sudo systemctl enable sddm

    read -rp "enter the username to autologin: " USER
    read -rp "enter the session to autologin: " SESSION

    if [[ -z "$USER" || -z "$SESSION" ]]; then
        log error "username and session cannot be empty"
        read -n 1 -s -r
        exit 1
    fi

    if ! id "$USER" &>/dev/null; then
        log error "user '$USER' does not exist"
        read -n 1 -s -r
        exit 1
    fi

    sudo mkdir -p "$CONFIG_DIR" || { log error "Failed to create directory $CONFIG_DIR"; exit 1; }

    sudo tee "$CONFIG_FILE" > /dev/null <<EOF
[Autologin]
User=$USER
Session=$SESSION
EOF

    if [[ $? -ne 0 ]]; then
        log error "failed to write SDDM autologin configuration"
        read -n 1 -s -r
        exit 1
    fi

    log success "SDDM autologin configured successfully"
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    sudo systemctl disable sddm
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${PACKAGES}"
    if [[ -f "$CONFIG_FILE" ]]; then
        sudo rm -f "$CONFIG_FILE" || { log error "Failed to remove $CONFIG_FILE"; exit 1; }
        log success "SDDM autologin configuration removed"
    else
        log info "SDDM autologin configuration not found"
    fi
fi
