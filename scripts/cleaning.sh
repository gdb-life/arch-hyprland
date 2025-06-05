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

# Remove packages
remove_packages() {
    local pkg_list=("$@")
    local to_delete=() # for deleted packages

    # Check existence packages in pkg_list
    if [[ ${#pkg_list[@]} -eq 0 ]]; then
        log warning "no packages to remove in $(readlink -f "$0")"
        return 0
    fi

    # Check existence packages in your system
    for pkg in "${pkg_list[@]}"; do
        if yay -Qi "$pkg" &>/dev/null; then
            to_delete+=("$pkg")
        else
            log warning "the package being deleted is not installed"
        fi
    done

    # Remove packages
    if [[ ! ${#to_delete[@]} -eq 0 ]]; then
        log info "deleting: ${to_delete[*]}"
        if yay -Rns "${to_delete[@]}"; then
            log success-deleted "${to_delete[*]}"
        else
            local exit_code=$?
            log error "failed to remove packages (exit code: $exit_code)"
            return $exit_code
        fi
    fi
}

# Remove configs
remove_configs() {
    local src="$1"  
    local dest="$2"

     # Сheck existence files
    [[ ! -e "$src" ]] && { log error "source '$src' not found!"; return 1; }

    # If src — dir 
    if [[ -f "$src" ]]; then
        local base="$(basename "$src")"
        local target="$dest/$base"
        local backup="$target.bak"

        [[ -e "$target" ]] && rm -f "$target" && log success-deleted "config '$target'"
        [[ -e "$backup" ]] && rm -f "$backup" && log success-deleted "backup '$backup'"

    # If src — file
    elif [[ -d "$src" ]]; then
        while IFS= read -r -d '' file; do
            local rel="${file#$src/}"
            local target="$dest/$rel"
            local backup="$target.bak"

            [[ -e "$target" ]] && rm -f "$target" && log success-deleted "config '$target'"
            [[ -e "$backup" ]] && rm -f "$backup" && log success-deleted "backup '$backup'"
        done < <(find "$src" -type f -print0)

        # Delete empty dirs
        find "$dest" -type d -empty -delete
    else
        log error "unsupported source type: '$src'"
        return 1
    fi
}
