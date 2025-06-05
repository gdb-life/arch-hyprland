#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"

# Logs
source "${REP_ROOT}/scripts/logs.sh"

PASS=(
    pass
)

BITWARDEN=(
    bitwarden
    bitwarden-cli
)

PACKAGES=(
    # Polkit
    polkit # privilege management system
    # polkit-gnome # GUI for polkit
    polkit-kde-agent
    hyprpolkitagent

    # Firewall
    nftables
    firewalld
)

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${PACKAGES[@]}"

    if ask_yes_no "Generate gpg key and pass init?" no; then
        install_packages "${PASS[@]}"
        gpg --full-generate-key
        GPG_ID=$(gpg --list-secret-keys --with-colons | awk -F: '/^fpr:/ {print $10; exit}')
        pass init $GPG_ID
    fi

    if ask_yes_no "Use Bitwarden?" no; then
        install_packages "${BITWARDEN[@]}"
    fi

    sudo systemctl enable --now nftables.service
    sudo systemctl enable --now firewalld.service
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${PACKAGES[@]}"
fi
