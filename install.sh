#!/bin/bash
# https://github.com/gdb-life/arch-hyprland

clear



# GLOBAL

REP_ROOT="$(git rev-parse --show-toplevel)"



# LOGS

source "${REP_ROOT}/scripts/logs.sh"

cd $REP_ROOT
if [ ! -d ${REP_ROOT}/logs ]; then
	mkdir logs
fi
export LOG="${REP_ROOT}/logs/$(date +%F_%T).log"
log success-created "log file '$LOG'"



# PRE-INSTALLATION

# Check if running as root
if [[ $EUID -eq 0 ]]; then
	log error "please execute as user"
	exit 1
fi

# Check if git installed
if [ ! pacman -Q git &> /dev/null ]; then
	sudo pacman -S git
	log success "git installed"
fi

# Check if yay installed
${REP_ROOT}/modules/yay.sh install



# INSTALATION

install_scripts=(
	# System module
	"${REP_ROOT}/modules/system/time.sh install"
	"${REP_ROOT}/modules/system/network.sh install"
	"${REP_ROOT}/modules/system/security.sh install"
	"${REP_ROOT}/modules/system/power.sh install"
	"${REP_ROOT}/modules/system/boot.sh install"
	"${REP_ROOT}/modules/system/shell.sh install"
	"${REP_ROOT}/modules/system/drivers.sh install"
	"${REP_ROOT}/modules/system/audio.sh install"
	"${REP_ROOT}/modules/system/bluetooth.sh install"

	# Window module
	"${REP_ROOT}/modules/window/hyprland.sh install"
	"${REP_ROOT}/modules/window/xdg.sh install"
	"${REP_ROOT}/modules/window/dialogs.sh install"
	"${REP_ROOT}/modules/window/panels.sh install"
	"${REP_ROOT}/modules/window/fonts.sh install"
	"${REP_ROOT}/modules/window/terminal.sh install"
	"${REP_ROOT}/modules/window/tools.sh install"
	"${REP_ROOT}/modules/window/gui.sh install"

	# Programs module
	"${REP_ROOT}/modules/programs.sh install"

	# My user packages
	"${REP_ROOT}/modules/my_programs.sh install"
)

for script in "${install_scripts[@]}"; do
	log run "$script"
	eval $script || exit $?
done
