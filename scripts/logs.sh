#!/bin/bash

WHITE="$(tput setaf 7)"
YELLOW="$(tput setaf 3)"
LIGHT_YELLOW="$(tput setaf 11)"
ORANGE="$(tput setaf 172)"
LIGHT_ORANGE="$(tput setaf 215)"
GREEN="$(tput setaf 2)"
LIGHT_GREEN="$(tput setaf 10)"
BLUE="$(tput setaf 6)"
LIGHT_BLUE="$(tput setaf 14)"
PURPLE="$(tput setaf 5)"
LIGHT_PURPLE="$(tput setaf 13)"
LIGHT_RED="$(tput setaf 9)"

INFO="${LIGHT_YELLOW}[ INFO ]${WHITE}"
WARNING="${LIGHT_ORANGE}[ WARN ]${WHITE}"
EXEC="${LIGHT_BLUE}[ EXEC ]${WHITE}"
SUCCESS="${LIGHT_GREEN}[  OK  ]${WHITE}"
PROMPT="${LIGHT_PURPLE}[ ^_^? ]${WHITE}"
ERROR="${LIGHT_RED}[FAILED]${WHITE}"

log() {
    local type=$1
    local message=$2
    case $type in
        info)               formatted="${INFO} $message" ;;
        info-installing)    formatted="${INFO} ${YELLOW}installing: ${WHITE}$message" ;;
        warning)            formatted="${WARNING} ${ORANGE}$message${WHITE}" ;;
        run)                formatted="\n${EXEC} ${BLUE}execute: ${WHITE}$message" ;;
        success)            formatted="${SUCCESS} $message" ;;
        success-created)    formatted="${SUCCESS} ${GREEN}created: ${WHITE}$message" ;;
        success-enabled)    formatted="${SUCCESS} ${GREEN}enabled: ${WHITE}$message" ;;
        success-installed)  formatted="${SUCCESS} ${GREEN}installed: ${WHITE}$message" ;;
        success-deleted)    formatted="${SUCCESS} ${GREEN}deleted: ${WHITE}$message" ;;
        prompt)             echo -ne "${PROMPT} ${PURPLE}$message${WHITE}" ; return ;;  # no newline
        error)              formatted="${ERROR} $message" ;;

        *)                  formatted="[ LOG ] $message" ;;
    esac

    echo -e "$formatted"

    if [[ -n "$LOG" ]]; then
        # Delete the ANSI escape codes before writing to the file
        local clean_message
        clean_message="$(echo -e "$formatted" | sed 's/\x1b\[[0-9;]*m//g')"
        echo "$clean_message" >> "$LOG"
    fi
}

ask_yes_no() {
    local question="$1"
    local default="${2:-yes}"  # yes if not specified
    local answer

    # Prompt formatting
    local suffix
    case "$default" in
        yes) suffix="[Y/n]" ;;
        no)  suffix="[y/N]" ;;
        *)   suffix="[y/n]" ;;
    esac

    # Ask the question
    local prompt_text="$question $suffix "
    log prompt "$prompt_text"
    read -r answer
    answer="${answer,,}"  # to lowercase

    # Handle empty input
    if [[ -z "$answer" ]]; then
        case "$default" in
            yes) return 0 ;;
            no)  return 1 ;;
            *)   return 1 ;;
        esac
    fi

    # Evaluate answer
    if [[ "$answer" =~ ^(y|yes)$ ]]; then
        return 0
    else
        return 1
    fi
}

wait_keypress() {
    # log info "Waiting for any key to be pressed..."
    read -n 1 -s -r -p "$(echo -e "${PROMPT} Press any key to continue...")"
    echo  # for newline
}
