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
    local pkg_file="$1"

    if [ ! -f "$pkg_file" 2>/dev/null ]; then
        log error "file $pkg_file not found! -_-"
        return 1
    fi
    
    while read -r pkg || [[ -n "$pkg" ]]; do
        if [[ -z "$pkg" || "$pkg" =~ ^# ]]; then
            continue
        fi

        if ! yay -Q "$pkg" &>/dev/null; then
            log warning "$pkg not found"
            continue
        fi

        pkg_list+=("$pkg")
    done < $pkg_file

    if [[ ${#pkg_list[@]} -eq 0 ]]; then
        log warning "no packages to remove in '$pkg_file'"
        return 0
    fi

    if yay -Rns --noconfirm "${pkg_list[@]}"; then
        log success "removed: ${pkg_list[*]}"
    else
        local exit_code=$?
        log error "failed to remove packages (exit code: $exit_code)"
        return $exit_code
    fi
}

# Remove configs
remove_configs() {
    local src_dir="$1"
    local dest_dir="$2"

    [[ ! -e "$src_dir" ]] && { log error "Source '$src_dir' not found!"; return 1; }
    [[ ! -d "$src_dir" ]] && { log error "Source '$src_dir' is not a directory!"; return 1; }
    [[ -z "$(ls -A "$src_dir")" ]] && { log warning "Source directory '$src_dir' is empty! Nothing to remove."; return 0; }

    while read -r -d '' src_file; do
        rel_path="${src_file#$src_dir/}"
        dest_file="$dest_dir/$rel_path"
        backup_file="${dest_file}.bak"

        if [[ -e "$dest_file" ]]; then
            rm -f "$dest_file" || { log error "failed to remove file: $dest_file"; return 1; }
        # else
        #     log warning "file not found (skipped): $dest_file"
        fi

        if [[ -e "$backup_file" ]]; then
            rm -f "$backup_file" || { log error "failed to remove backup: $backup_file"; return 1; }
        # else
        #     log warning "backup not found (skipped): $backup_file"
        fi
    done < <(find "$src_dir" -type f -print0)

    if [[ -d "$dest_dir" ]]; then
        find "$dest_dir" -type d -empty -delete
            # && log info "removed empty directories under '$dest_dir'" \
            # || log warning "Some empty directories could not be removed under '$dest_dir'"
    fi

    log success "files removed from '$dest_dir'"
    return 0
}
