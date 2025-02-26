#!/bin/bash

# colors
GREEN="\e[32m"
YELLOW="\e[33m"
ORANGE="\e[38;5;208m"
RED="\e[31m"
RESET="\e[0m"

# logs
log() {
    local type=$1
    local message=$2
    case $type in
        info) echo -e "${YELLOW}[INFO]${RESET} $message" ;;
        warning) echo -e "${YELLOW}[INFO]${RESET} ${ORANGE}$message${RESET}" ;;
        success) echo -e "${GREEN}[SUCCESS]${RESET} $message" ;;
        error) echo -e "${RED}[ERROR]${RESET} $message" ;;
        done) echo -e "${YELLOW}[INFO]${RESET} ${GREEN}Done${RESET}" ;;
    esac
}