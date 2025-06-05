#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"

# Packages categories
viewers=(
    tk
)

editors=(
    obsidian
    qtcreator
    arduino-ide
    visual-studio-code-bin
)

pylibs=(
    python-numpy
    python-matplotlib
    python-pandas
    python-plotly
)

latex=(
    texstudio
    texmaker
    texlive-full
    # texlive-basic
    # texlive-langcyrillic
)

virtualization=(
    virtualbox
    virtualbox-host-dkms
    docker
)

tools=(
    kdeconnect
)

# Combining all categories
PACKAGES=(
    "${viewers[@]}"
    "${editors[@]}"
    "${pylibs[@]}"
    "${latex[@]}"
    "${virtualization[@]}"
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
