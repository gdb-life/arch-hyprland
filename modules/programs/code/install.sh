#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${MODULE_DIR}/packages.txt"

    # docker
    sudo systemctl enable docker.socket
    gpg --generate-key
    echo "you need to run \"pass init <your-gpg-key-id>\" (~/.gnupg)"
    echo "you can list your gpg keys with \"gpg --list-keys\""
    echo "later run \"docker login\""
    read -n 1 -s -r
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${MODULE_DIR}/packages.txt"
fi
