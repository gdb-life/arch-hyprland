#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"

MINEGRUB_THEME_REPO="https://github.com/Lxtharia/double-minegrub-menu.git"
MINEGRUB_THEME_DIR_NAME="double-minegrub-menu"
MINEGRUB_THEME_NAME="minegrub-world-selection"

MINESDDM_THEME_REPO="https://github.com/Davi-S/sddm-theme-minesddm.git"
MINESDDM_THEME_DIR_NAME="sddm-theme-minesddm"
MINESDDM_THEME_NAME="minesddm"
MINESDDM_CLONE_TARGET_PATH="/usr/share/sddm/themes"
SDDM_CONFIG_DIR="/etc/sddm.conf.d"
SDDM_CONFIG_SRC="${MODULE_DIR}/configs/themes.conf"

# Logs
source "${REP_ROOT}/scripts/logs.sh"

PACKAGES=(
    sddm
)

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${PACKAGES[@]}"
    sudo systemctl enable sddm.service
    log success-enabled "sddm.service"

    # Install grub theme
    if ask_yes_no "Do you wont to install minegrub grub theme?" no; then
        if git clone --depth 1 "$MINEGRUB_THEME_REPO" "/tmp/$MINEGRUB_THEME_DIR_NAME"; then
            # log success "minegrub-theme cloned to /tmp/$MINEGRUB_THEME_DIR_NAME"
            pushd "/tmp/$MINEGRUB_THEME_DIR_NAME" > /dev/null || exit 1
            if sudo ./install.sh; then
                log success "grub minegrub theme installed"
            else
                log error "failed to install minegrub-theme"
            fi
            popd > /dev/null || exit 1
            sudo rm -rf "/tmp/$MINEGRUB_THEME_DIR_NAME"
        else
            log error "failed to clone minegrub-theme"
        fi
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        # wait_keypress
    fi

    # Install sddm theme
    if ask_yes_no "Do you wont to install minesddm sddm theme?" no; then
        if git clone --depth 1 "$MINESDDM_THEME_REPO" "/tmp/$MINESDDM_THEME_DIR_NAME"; then
            pushd "/tmp/$MINESDDM_THEME_DIR_NAME" > /dev/null || exit 1
            ls -al
            sudo cp -r $MINESDDM_THEME_NAME $MINESDDM_CLONE_TARGET_PATH
            popd > /dev/null || exit 1
            sudo rm -rf "/tmp/$MINESDDM_THEME_DIR_NAME"

            sudo mkdir -p "$SDDM_CONFIG_DIR" || { log error "failed to create directory $SDDM_CONFIG_DIR"; exit 1; }
            copy_configs "$SDDM_CONFIG_SRC" "$SDDM_CONFIG_DIR"
            log success "sddm minesddm theme installed"
        else
            log error "failed to clone sddm-theme-minesddm"
        fi
    fi

fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    # remove_packages "${PACKAGES[@]}"

    # Uninstall grub theme
    if [[ -d "/boot/grub/themes/$MINEGRUB_THEME_NAME" ]]; then
        sudo rm -rf "/boot/grub/themes/$MINEGRUB_THEME_NAME"
        log warning "delete theme in config and grub-mkconfig manually"
        log success-deleted "grub $MINEGRUB_THEME_NAME theme uninstalled"
    fi

    # Uninstall sddm theme
    if [[ -d "$MINESDDM_CLONE_TARGET_PATH/$MINEGRUB_THEME_NAME" ]]; then
        sudo rm -rf "${MINESDDM_CLONE_TARGET_PATH}/${MINEGRUB_THEME_NAME}"
        remove_configs "$SDDM_CONFIG_SRC" "$SDDM_CONFIG_DIR"
        log success-deleted "sddm ${MINEGRUB_THEME_NAME} theme uninstalled"
    fi
fi
