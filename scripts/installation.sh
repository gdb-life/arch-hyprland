#!/bin/bash
set -eo pipefail

# Global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
# REP_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || {
#     echo "Error: Not in a Git repository!" >&2
#     return 1
# }

# Logs
source "${REP_ROOT}/scripts/logs.sh"

# Install packages
install_packages() {
    local pkg_list=("$@")
    local to_install=() # for installation packages
    local installed=()  # for already isntalled packages

    # Check existence packages in pkg_list
    if [[ ${#pkg_list[@]} -eq 0 ]]; then
        log warning "no packages to install in $(readlink -f "$0")"
        return 0
    fi

    # Check existence packages in your system and repositories
    for pkg in "${pkg_list[@]}"; do
        if yay -Qi "$pkg" &>/dev/null; then
            installed+=("$pkg")
        else
            if yay -Si "$pkg" &>/dev/null; then
                to_install+=("$pkg")
            else
                log error "$pkg not found in repositories"
                return 1
            fi
        fi
    done

    # Print already installed packages
    if [[ ${#installed[@]} -gt 0 ]]; then
        log success "already installed: ${installed[*]}"
    fi

    # Install packages
    # --needed — do not reinstall up to date packages
    # --answerdiff=None — does not show differences (Diffs to show?);
    # --answerclean=None — does not offer cleaning (Packages to cleanBuild?);
    if [[ ! ${#to_install[@]} -eq 0 ]]; then
        log info-installing "${to_install[*]}"
        if yay -S --needed --answerdiff=None --answerclean=None "${to_install[@]}"; then
            log success-installed "${to_install[*]}"
        else
            local exit_code=$?
            log error "failed to install packages (exit code: $exit_code)"
            return $exit_code
        fi
    fi
}

# Backup files
backup_file() {
    local file_path="$1"
    local dir="$(dirname "$file_path")"
    local base="$(basename "$file_path")"

    # Check existence old backup
    local old_backup=$(find "$dir" -maxdepth 1 -name "${base}.bak*" | head -n1)
    if [[ -n "$old_backup" ]]; then
        if command -v trash-put &>/dev/null; then
            trash-put "$old_backup" && log info "moved to trash: previous backup '$old_backup'"
        else
            rm -f "$old_backup" && log warning "deleted: previous backup '$old_backup'"
        fi
    fi

    # local timestamp="$(date +%F_%T)"
    # local bak_path="${file_path}.bak.$timestamp"
    local bak_path="${file_path}.bak"
    sudo cp "$file_path" "$bak_path" || return 1
    log success-created "backup '$bak_path'"
}

# Copying configs
copy_configs() {
    local src="$1"      # config file or dir
    local dest="$2"     # destination dir

    # Сheck existence files
    [[ ! -e "$src" ]] && { log error "$src not found!"; return 1; }

    # Create destination dir
    mkdir -p "$dest" || { log error "failed to create directory '$dest'"; return 1; }

    # If src — dir
    if [[ -d "$src" ]]; then
        while IFS= read -r -d '' file; do
            rel="${file#$src/}"
            target="$dest/$rel"
            # Create backup files
            if [[ -e "$target" ]]; then
                backup_file "$target" || { log error "backup failed for '$target'"; return 1; }
            fi            
            sudo cp -f "$file" "$target" || { log error "copy failed: $file → $target"; return 1; }
            log success-created "config '$target'"
        done < <(find "$src" -type f -print0)

    # If src — file
    elif [[ -f "$src" ]]; then
        local base="$(basename "$src")"
        local target="$dest/$base"
        if [[ -e "$target" ]]; then
            backup_file "$target" || { log error "backup failed for '$target'"; return 1; }
        fi
        sudo cp -f "$src" "$target" || { log error "copy failed: $src → $target"; return 1; }
        log success-created "config '$target'"
    else
        log error "unsupported source type: '$src'"
        return 1
    fi
}
