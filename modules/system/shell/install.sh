#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"
PACKAGES="${MODULE_DIR}/packages.txt"

# Logs
source "${REP_ROOT}/scripts/logs.sh"

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${PACKAGES}"

    # Install Oh My Zsh
    log info "Installing Oh My Zsh..."
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        if command -v wget > /dev/null; then
            sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" ""
            if [ $? -ne 0 ]; then
                log error "error installing Oh My Zsh."
                exit 1
            fi
        else
            log error "wget not found. Install wget."
            exit 1
        fi
    fi

    # Install theme
    log info "Installing theme Powerlevel10k..."
    yay -S --noconfirm --needed zsh-theme-powerlevel10k-git
    ZSHRC_FILE="$HOME/.zshrc"
    P10K_SOURCE_LINE='source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme'
    if [ -f "$ZSHRC_FILE" ] && ! grep -qxF "$P10K_SOURCE_LINE" "$ZSHRC_FILE"; then
        echo "$P10K_SOURCE_LINE" >> "$ZSHRC_FILE"
    elif [ ! -f "$ZSHRC_FILE" ]; then
         log error "${ZSHRC_FILE} not found"
    else
        log warning "Powerlevel10k is already present in ${ZSHRC_FILE}."
    fi

    # Install plugins
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    PLUGINS_DIR="${ZSH_CUSTOM}/plugins"
    mkdir -p "$PLUGINS_DIR" 

    # zsh-autosuggestions
    AUTOSUGGEST_DIR="${PLUGINS_DIR}/zsh-autosuggestions"
    if [ ! -d "$AUTOSUGGEST_DIR" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGEST_DIR"
    else
        (cd "$AUTOSUGGEST_DIR" && git pull)
    fi

    # zsh-syntax-highlighting
    SYNTAX_HIGHLIGHT_DIR="${PLUGINS_DIR}/zsh-syntax-highlighting"
    if [ ! -d "$SYNTAX_HIGHLIGHT_DIR" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$SYNTAX_HIGHLIGHT_DIR"
    else
        (cd "$SYNTAX_HIGHLIGHT_DIR" && git pull)
    fi

    if [ -f "$ZSHRC_FILE" ]; then
        log info "create backup ${ZSHRC_FILE}.bak.$(date +%F_%T)"
        cp "$ZSHRC_FILE" "${ZSHRC_FILE}.bak.$(date +%F_%T)"

        # sudo
        if grep -q '^plugins=(.*sudo.*)' "$ZSHRC_FILE"; then
             log warning "sudo is already present in ${ZSHRC_FILE}."
        else
             sed -i '/^plugins=(/ s/)$/ sudo)/' "$ZSHRC_FILE"
        fi

        # zsh-syntax-highlighting
        if grep -q '^plugins=(.*zsh-syntax-highlighting.*)' "$ZSHRC_FILE"; then
            log warning "zsh-syntax-highlighting is already present in ${ZSHRC_FILE}."
        else
            sed -i '/^plugins=(/ s/)$/ zsh-syntax-highlighting)/' "$ZSHRC_FILE"
        fi

        # zsh-autosuggestions
        if grep -q '^plugins=(.*zsh-autosuggestions.*)' "$ZSHRC_FILE"; then
             log warning "zsh-autosuggestions is already present in ${ZSHRC_FILE}."
        else
             sed -i '/^plugins=(/ s/)$/ zsh-autosuggestions)/' "$ZSHRC_FILE"
        fi

        if [ $? -ne 0 ]; then
            log error "error when changing ${ZSHRC_FILE}"
            exit 1
        fi
    else
        log error "${ZSHRC_FILE} not found"
        exit 1
    fi
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${PACKAGES}"
    log warning "restore the backup file and delete all unnecessary manually"
fi
