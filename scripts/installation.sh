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
    local pkg_file="$1"

    if [ ! -f "$pkg_file" 2>/dev/null ]; then
        log error "file $pkg_file not found! -_-"
        return 1
    fi

    while read -r pkg || [[ -n "$pkg" ]]; do
        if [[ -z "$pkg" || "$pkg" =~ ^# ]]; then
            continue
        fi

        if yay -Qi "$pkg" &>/dev/null; then
            log success "$pkg already installed"
            continue
        else 
            if ! yay -Si "$pkg" &>/dev/null; then
                log error "$pkg not found in repositories"
                return 1
            fi
        fi

        pkg_list+=("$pkg")
    done < $pkg_file

    if [[ ${#pkg_list[@]} -eq 0 ]]; then
        # log warning "no packages to install in '$pkg_file'"
        return 0
    fi
    
    if yay -S --noconfirm --needed "${pkg_list[@]}"; then
        log success "installed: ${pkg_list[*]}"
    else
        local exit_code=$?
        log error "failed to install packages (exit code: $exit_code)"
        return $exit_code
    fi
}

# Copying configs
copy_configs() {
    local src_dir="$1"
    local dest_dir="$2"

    [[ ! -e "$src_dir" ]] && { log error "$src_dir not found!"; return 1; }
    [[ ! -d "$src_dir" ]] && { log error "'$src_dir' is not a directory!"; return 1; }
    [[ -z "$(ls -A "$src_dir")" ]] && { log warning "source directory '$src_dir' is empty!"; return 0; }

    mkdir -p "$dest_dir" || { log error "failed to create directory '$dest_dir'"; return 1; }

    while read -r -d '' src_file; do
        rel_path="${src_file#$src_dir/}"
        dest_file="$dest_dir/$rel_path"

        if [[ -e "$dest_file" ]]; then
            cp -f "$dest_file" "${dest_file}.bak" || { log error "backup failed for $dest_file"; return 1; }
            # log info "backup created: ${dest_file}.bak"
        fi

        cp -f "$src_file" "$dest_file" || { log error "copy failed: $src_file → $dest_file"; return 1; }
        # log info "copied $rel_path"
    done < <(find "$src_dir" -type f -print0)

       
    # cp -r --remove-destination "$src_dir"/* "$dest_dir" || { log error "error copying configs to $dest_dir"; return 1; }
    log success "configs copied to $dest_dir"
}
