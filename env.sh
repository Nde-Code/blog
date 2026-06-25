#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' 

echo -e "${BLUE}Hugo blog environment check: ${NC}"

check_command() {
    local cmd=$1
    local description=$2
    
    if command -v "$cmd" &> /dev/null; then

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
check_command "go" "Go Language (required for Hugo modules)"

if command -v hugo &> /dev/null; then
    HUGO_VERSION=$(hugo version)
    if [[ $HUGO_VERSION == *"extended"* ]]; then
        echo -e "[${GREEN}OK${NC}] Hugo Static Site Generator (EXTENDED version detected). ($HUGO_VERSION)"
    else
        YEL='\033[0;33m'
        echo -e "[${YEL}WARNING${NC}] Hugo is installed but it is NOT the 'extended' version. Your theme might fail to compile Sass/SCSS files."
    fi
else
    echo -e "[${RED}MISSING${NC}] Hugo is NOT installed!"
fi

check_command "node" "Node.js Runtime"