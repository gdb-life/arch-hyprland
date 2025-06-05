#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
CONFIG_FILE="$HOME/.config/user-dirs.dirs"

PACKAGES=(
    xdg-user-dirs
    xdg-desktop-portal
    xdg-desktop-portal-hyprland # wayland backend
)

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${PACKAGES[@]}"

    # Create user dirs

    if [ -f "$CONFIG_FILE" ]; then
        rm -f "$CONFIG_FILE" || { log error "failed to remove old config file"; exit 1; }
    fi

    mkdir -p "$(dirname "$CONFIG_FILE")" || { log error "failed to create config directory"; exit 1; }

    mkdir -p "$HOME/desktop" "$HOME/downloads" "$HOME/documents" \
            "$HOME/music" "$HOME/pictures" "$HOME/videos" \
            "$HOME/templates" "$HOME/public" || { log error "failed to create XDG directories"; exit 1; }

    cat > "$CONFIG_FILE" <<EOF || { log error "failed to write to $CONFIG_FILE"; exit 1; }
XDG_DESKTOP_DIR="\$HOME/desktop"
XDG_DOWNLOAD_DIR="\$HOME/downloads"
XDG_DOCUMENTS_DIR="\$HOME/documents"
XDG_MUSIC_DIR="\$HOME/music"
XDG_PICTURES_DIR="\$HOME/pictures"
XDG_VIDEOS_DIR="\$HOME/videos"
XDG_TEMPLATES_DIR="\$HOME/templates"
XDG_PUBLICSHARE_DIR="\$HOME/public"
EOF

    xdg-user-dirs-update || { log error "failed to update xdg-user-dirs"; exit 1; }

    log success "xdg-user-dirs configuration installed"
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${PACKAGES[@]}"

    if [ -f "$CONFIG_FILE" ]; then
        rm -f "$CONFIG_FILE" || { log error "failed to remove config file"; exit 1; }
    fi

    log success "xdg-user-dirs configuration uninstalled"
fi
