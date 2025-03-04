#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"

# Logs
source "${REP_ROOT}/scripts/logs.sh"

# Install packages
install_packages() {
    local pkg_file="$1"

    if [ ! -f "$pkg_file" ]; then
        log error "file $pkg_file not found!"
        read -n 1 -s -r
        exit 1
    fi

    local packages
    packages=$(cat "$pkg_file")

    for package in $packages; do
        if pacman -Qi "$package" &>/dev/null; then
            log success "$package already installed"
        else
            if sudo pacman -S --noconfirm --needed "$package"; then
                log success "$package installed"
            else
                log error "error installing $package"
                read -n 1 -s -r
                exit 1
            fi
        fi
    done
}

# Copying configs
copy_configs() {
    local config_src="$1"
    local config_dest="$2"

    if [ ! -d "$config_src" ]; then
        log error "directory $config_src not found!"
        read -n 1 -s -r
        exit 1
    fi

    mkdir -p "$config_dest"
    if cp -r --remove-destination "$config_src"/* "$config_dest"; then
        log success "configs copied to $config_dest"
    else
        log error "error copying configs to $config_dest"
        read -n 1 -s -r
        exit 1
    fi
}
