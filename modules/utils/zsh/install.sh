#!/bin/bash

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
MODULE_DIR="$(dirname "$0")"
ZSHRC_PATH="$HOME/.zshrc"
PLUGINS=("zsh-syntax-highlighting" "zsh-autosuggestions")

# Logs
source "${REP_ROOT}/scripts/logs.sh"

# Install
if [ "$1" == "install" ]; then
    source "${REP_ROOT}/scripts/installation.sh"
    install_packages "${MODULE_DIR}/packages.txt"

    # Install Oh My Zsh interactively if not already installed
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    # Install powerlevel10k theme
    yay -S --noconfirm zsh-theme-powerlevel10k-git
    grep -q "powerlevel10k.zsh-theme" "$ZSHRC_PATH" || \
        echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >> "$ZSHRC_PATH"

    # Install plugins if not already installed
    for plugin in "${PLUGINS[@]}"; do
        plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin"
        if [ ! -d "$plugin_dir" ]; then
            case "$plugin" in
                "zsh-autosuggestions")
                    git clone https://github.com/zsh-users/zsh-autosuggestions "$plugin_dir"
                    ;;
                "zsh-syntax-highlighting")
                    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugin_dir"
                    ;;
            esac
        fi
    done

    # Update plugins in .zshrc
    if grep -q "^plugins=(" "$ZSHRC_PATH"; then
        # If plugins line exists, update it
        sed -i '/^plugins=(/ c\plugins=(git sudo zsh-syntax-highlighting zsh-autosuggestions)' "$ZSHRC_PATH"
    else
        # If no plugins line exists, add it
        echo -e "\nplugins=(git sudo zsh-syntax-highlighting zsh-autosuggestions)" >> "$ZSHRC_PATH"
    fi

    # Change default shell to zsh (this will prompt for password)
    if [ "$SHELL" != "/usr/bin/zsh" ]; then
        chsh -s /usr/bin/zsh
    fi

    log success "zsh installed and configured"
    echo "Please restart your terminal to complete the setup"
    echo "After restart, p10k will guide you through the PowerLevel10k configuration"
fi

# Uninstall
if [ "$1" == "uninstall" ]; then
    source "${REP_ROOT}/scripts/cleaning.sh"
    
    # Remove zsh-completions first if it exists
    if pacman -Qi zsh-completions &>/dev/null; then
        sudo pacman -Rns --noconfirm zsh-completions || { log error "failed to remove zsh-completions"; exit 1; }
    fi
    
    # Modify packages.txt temporarily to exclude zsh-completions
    TEMP_PACKAGES=$(grep -v "zsh-completions" "${MODULE_DIR}/packages.txt")
    remove_packages <(echo "$TEMP_PACKAGES") || { log error "failed to remove packages"; exit 1; }

    if [ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        rm -rf "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" || { log error "failed to remove zsh-autosuggestions plugin"; exit 1; }
    fi

    if [ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        rm -rf "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" || { log error "failed to remove zsh-syntax-highlighting plugin"; exit 1; }
    fi

    yay -Rns --noconfirm zsh-theme-powerlevel10k-git || { log error "failed to remove powerlevel10k"; exit 1; }

    if [ -d "$HOME/.oh-my-zsh" ]; then
        rm -rf "$HOME/.oh-my-zsh" || { log error "failed to remove oh-my-zsh"; exit 1; }
    fi

    sudo sed -i 's#/usr/bin/zsh#/bin/bash#' /etc/passwd || { log error "failed to restore default shell"; exit 1; }

    if [ -f "$ZSHRC_PATH" ]; then
        rm -f "$ZSHRC_PATH" || { log error "failed to remove .zshrc"; exit 1; }
    fi

    sudo sed -i 's#^$(whoami):[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:/.*#$(whoami):x:1000:1000::/home/$(whoami):/usr/bin/bash#' /etc/passwd || { log error "failed to restore default shell"; exit 1; }

    log success "zsh uninstalled successfully"
fi