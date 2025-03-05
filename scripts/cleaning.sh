#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"

# Logs
source "${REP_ROOT}/scripts/logs.sh"

# Remove packages
remove_packages() {
    local pkg_file="$1"

    if [ ! -f "$pkg_file" ]; then
        log error "file $pkg_file not found!"
        read -n 1 -s -r
        exit 1
    fi

    local packages
    packages=$(cat "$pkg_file")

    for package in $packages; do
        yay -Rns --noconfirm "$package" || { log error "error removing $package"; exit 1; }
        log success "$package removed"
    done
}

# Remove configs
remove_configs() {
    local config_src="$1"
    local config_dest="$2"

    if [ ! -d "$config_src" ]; then
        log error "directory $config_src not found!"
        read -n 1 -s -r
        exit 1
    fi

    rm -rf "$config_dest"

    if [ ! -e "$config_dest" ]; then
        log success "configs removed from $config_dest"
    else
        log error "error removing configs from $config_dest"
        read -n 1 -s -r
        exit 1
    fi

    local parent_dir
    parent_dir=$(dirname "$config_dest")

    if [ -d "$parent_dir" ] && [ -z "$(ls -A "$parent_dir")" ]; then
        rmdir "$parent_dir" || { log error "error removing empty directory $parent_dir"; exit 1; }
        log success "empty directory $parent_dir removed"
    fi
}
