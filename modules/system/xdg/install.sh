#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"
CONFIG_FILE="$HOME/.config/user-dirs.dirs"

# Logs
source "${REP_ROOT}/scripts/logs.sh"

# Install
if [ "$1" == "install" ]; then
    if [ -f "$CONFIG_FILE" ]; then
        rm -f "$CONFIG_FILE" || { log error "Failed to remove old config file"; exit 1; }
    fi

    mkdir -p "$(dirname "$CONFIG_FILE")" || { log error "Failed to create config directory"; exit 1; }

    cat > "$CONFIG_FILE" <<EOF || { log error "Failed to write to $CONFIG_FILE"; exit 1; }
XDG_DESKTOP_DIR="\$HOME/desktop"
XDG_DOWNLOAD_DIR="\$HOME/downloads"
XDG_DOCUMENTS_DIR="\$HOME/documents"
XDG_MUSIC_DIR="\$HOME/music"
XDG_PICTURES_DIR="\$HOME/pictures"
XDG_VIDEOS_DIR="\$HOME/videos"
XDG_TEMPLATES_DIR="\$HOME/templates"
XDG_PUBLICSHARE_DIR="\$HOME/public"
EOF

    xdg-user-dirs-update --force || { log error "xdg-user-dirs-update failed"; exit 1; }

    log success "xdg-user-dirs configuration installed"
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    if [ -f "$CONFIG_FILE" ]; then
        rm -f "$CONFIG_FILE" || { log error "Failed to remove config file"; exit 1; }
    fi

    log success "xdg-user-dirs configuration uninstalled"
fi
