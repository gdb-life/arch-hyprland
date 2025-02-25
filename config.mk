# config.mk

# repo root
REP_ROOT=$(shell git rev-parse --show-toplevel)

# dirs
CONFIGS_DIR=$(REP_ROOT)/configs
SCRIPTS_DIR=$(REP_ROOT)/scripts
INSTALL_DIR=$(HOME)/.config

# colors
GREEN=\033[0;32m
RED=\033[0;31m
YELLOW=\033[0;33m
RESET=\033[0m
