#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"

# Packages categories
qt=(
    # Qt5
    qt5-base 
    python-pyqt5 
    qt5-wayland

    # Qt6
    qt6-base
    python-pyqt6
    qt6-wayland
)

gtk=(
    # For GObject
    python-gobject
    gobject-introspection 

    # For 2D graphics backends
    cairo 
    python-cairo

    gtk2
    gtk3
    gtk4

    dbus-glib
)

# Combining all categories
PACKAGES=(
    "${qt[@]}"
    "${gtk[@]}"
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
