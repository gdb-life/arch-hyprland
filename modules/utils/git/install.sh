#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"
PACKAGES="${MODULE_DIR}/packages.txt"

# Logs
source "${REP_ROOT}/scripts/logs.sh"

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${PACKAGES}"

    read -rp "enter the username: " USER
    read -rp "enter the email: " EMAIL

   if [[ -z "$USER" || -z "$EMAIL" ]]; then
        log error "username and email cannot be empty"
        read -n 1 -s -r
        exit 1
    fi

    git config --global user.name "$USER"
    git config --global user.email "$EMAIL"

    log success "git configured successfully"
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${PACKAGES}"

    git config --global --unset user.name
    git config --global --unset user.email

    log success "git uninstalled successfully"
fi
