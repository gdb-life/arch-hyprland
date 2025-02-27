#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"

# Logs
source "${REP_ROOT}/scripts/logs.sh"

# Install packages
install_packages() {
    local pkg_file="$1"

    if [ ! -f "$pkg_file" ]; then
        log error "File $pkg_file not found!"
        exit 1
    fi

    local packages
    packages=$(cat "$pkg_file")

    for package in $packages; do
        if pacman -Qi "$package" &>/dev/null; then
            log success "$package already installed"
        else
            log info "Installing $package..."
            sudo pacman -S --noconfirm --needed "$package" && log success "$package installed" || {
                log error "Error installing $package"
                exit 1
            }
        fi
    done
}

# Copying configs
copy_configs() {
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
