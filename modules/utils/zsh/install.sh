#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom/plugins"
ZSHRC_PATH="$HOME/.zshrc"
OH_MY_ZSH_INSTALL_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

# Logs
source "${REP_ROOT}/scripts/logs.sh"

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${MODULE_DIR}/packages.txt"

    sudo sed -i 's#^$(whoami):[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:/.*#$(whoami):x:1000:1000::/home/$(whoami):/usr/bin/zsh#' /etc/passwd

    sh -c "$(wget -O- $OH_MY_ZSH_INSTALL_URL)"

    yay -S --noconfirm zsh-theme-powerlevel10k-git
    echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >> $ZSHRC_PATH

    mkdir -p "$ZSH_CUSTOM" || { log error "could not create $ZSH_CUSTOM"; exit 1; }
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/zsh-syntax-highlighting

    echo -e "\nplugins=(git sudo zsh-syntax-highlighting zsh-autosuggestions)" >> "$ZSHRC_PATH"

    cd "$HOME/arch-hyprland" || { log error "could not change to $HOME/arch-hyprland"; exit 1; }

    log success "zsh installed and configured"
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    remove_packages "${MODULE_DIR}/packages.txt" || { log error "failed to remove packages"; exit 1; }

    rm -rf "$ZSH_CUSTOM/zsh-autosuggestions" "$ZSH_CUSTOM/zsh-syntax-highlighting" && \
    log success "zsh plugins removed" || { log error "failed to remove zsh plugins"; exit 1; }

    yay -Rns --noconfirm zsh-theme-powerlevel10k-git && \
    log success "powerlevel10k removed" || { log error "failed to remove powerlevel10k"; exit 1; }

    rm -rf "$HOME/.oh-my-zsh" && \
    log success "oh-my-zsh removed" || { log error "failed to remove oh-my-zsh"; exit 1; }

    sudo sed -i 's#/usr/bin/zsh#/bin/bash#' /etc/passwd && \
    log success "default shell restored to bash" || { log error "failed to restore default shell"; exit 1; }

    rm -f "$ZSHRC_PATH" && \
    log success ".zshrc removed" || { log error "failed to remove .zshrc"; exit 1; }

    log done
fi