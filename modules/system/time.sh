#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"

# Logs
source "${REP_ROOT}/scripts/logs.sh"

# Install
if [ "$1" == "install" ]; then
    sudo timedatectl set-timezone Europe/Minsk
    log success-enabled "timezone Europe/Minsk"

    sudo timedatectl set-ntp 1
    log success-enabled "ntp"

    sudo timedatectl set-local-rtc 0
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    sudo timedatectl set-timezone Etc/UTC
    # sudo timedatectl set-ntp 0
fi
