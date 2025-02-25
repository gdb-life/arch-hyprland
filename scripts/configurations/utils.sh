#!/bin/bash

# global variables
REP_ROOT="$(git rev-parse --show-toplevel)"
source ${REP_ROOT}/scripts/.env
module=$1

# logs
source ${REP_ROOT}/scripts/logs.sh

# check dirs for xdg-user-dirs
log info "Creating and setting users dirs..."
if [[ ! -f ${INSTALL_DIR}/user-dirs.dirs ]]; then
cat <<EOL > ${INSTALL_DIR}/user-dirs.dirs
XDG_DESKTOP_DIR="\$HOME/desktop"
XDG_DOWNLOAD_DIR="\$HOME/downloads"
XDG_DOCUMENTS_DIR="\$HOME/documents"
XDG_MUSIC_DIR="\$HOME/music"
XDG_PICTURES_DIR="\$HOME/pictures"
XDG_VIDEOS_DIR="\$HOME/videos"
XDG_TEMPLATES_DIR="\$HOME/templates"
XDG_PUBLICSHARE_DIR="\$HOME/public"
EOL
fi
dirs=(desktop downloads documents music pictures videos templates public)
for dir in ${dirs[@]}; do
    if [[ ! -d $HOME/$dir ]]; then
        mkdir -p $HOME/$dir 
        log success "created dir $HOME/$dir"
    fi
done
xdg-user-dirs-update

# for screenshots
mkdir -p ~/pictures/screenshots

log done
