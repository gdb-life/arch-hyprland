#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"
YAY_DIR="/tmp/yay"

# Logs
source "${REP_ROOT}/scripts/logs.sh"

# Install
if [ "$1" == "install" ]; then
    if command -v yay &>/dev/null; then
        log success "yay already installed"
        exit 0
    fi

    if ! git clone https://aur.archlinux.org/yay.git "$YAY_DIR"; then
        log error "error cloning yay!"
        exit 1
    fi

    cd "$YAY_DIR" || exit 1

    if ! makepkg -sirc --noconfirm; then
        log error "error building yay!"
        exit 1
    fi

    cd "$REP_ROOT" || exit 1
    log success "yay installed"
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    if ! command -v yay &>/dev/null; then
        log info "yay not installed"
        exit 0
    fi

    if ! sudo pacman -Rns --noconfirm yay; then
        log error "error removing yay!"
        exit 1
    fi

    rm -rf "$YAY_DIR"

    log success "yay successfully removed!"
fi
