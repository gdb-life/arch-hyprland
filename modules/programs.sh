#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"

# Packages categories
internet=(
    # Browser
    firefox
    # google-chrome

    # Download
    qbittorrent

    # Mail
    thunderbird

    # Chat
    discord
    telegram-desktop
)

files=(
    # Manager
    dolphin
    kio-admin # for dolphin --sudo

    # Archive
    ark
)

office=(
    libreoffice-fresh
    qalculate-gtk # calc

    # Docs
    zathura
    zathura-djvu
    zathura-pdf-poppler
)

editors=(
    sublime-text-4
)

media=(
    feh # need for screenshots
    gwenview # for photos, videos, gifs

    audacious # for audio
)

tools=(
    # Monitoring
    bashtop
    htop
    glances
    fastfetch

    # Develop
    cmake
    gdb

    # Storage
    ntfs-3g
    dosfstools
    udisks2
    udiskie
    unzip
    unrar
    zip
    tree
    mc
    rsync
)

# Combining all categories
PACKAGES=(
    "${internet[@]}"
    "${files[@]}"
    "${office[@]}"
    "${editors[@]}"
    "${media[@]}"
    "${tools[@]}"
)

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${PACKAGES[@]}"
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${PACKAGES[@]}"
fi
