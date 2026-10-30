#!/bin/bash
# Code formatted with https://www.codeclean.net/tools/bash/ using 4-space indentation.

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Hugo blog environment check: ${NC}"

check_command() {
    local cmd=$1
    local description=$2

    if command -v "$cmd" &>/dev/null; then

        if [ "$cmd" = "go" ]; then
            local version=$(go version 2>&1)
        else
            local version=$($cmd --version 2>&1 | head -n 1)
        fi

        echo -e "[${GREEN}OK${NC}] $description ($cmd) is installed. ($version)"
    else
        echo -e "[${RED}MISSING${NC}] $description ($cmd) is NOT installed!"
    fi
}

check_command "git" "Git Version Control"
check_command "go" "Go Language (required for Hugo Modules)"
check_command "hugo" "Hugo Static Site Generator"
