#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"

# Logs
source "${REP_ROOT}/scripts/logs.sh"

# Copying configs
install_configs() {
    local config_src="$1"
    local config_dest="$2"

    if [ ! -d "$config_src" ]; then
        log error "directory $config_src not found!"
        exit 1
    fi

    mkdir -p "$config_dest"
    cp -r --remove-destination "$config_src"/* "$config_dest"

    log success "configs copied to $config_dest"
}
