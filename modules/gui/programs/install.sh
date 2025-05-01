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

    # docker
    sudo systemctl enable docker.socket
    gpg --generate-key
    log warning "you need to run \"pass init <your-gpg-key-id>\" (~/.gnupg)"
    log warning "you can list your gpg keys with \"gpg --list-keys\""
    log warning "later run \"docker login\""

    # virtual box
    sudo modprobe vboxdrv vboxnetflt vboxnetadp vboxpci
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${PACKAGES}"
fi
