#!/bin/sh

# Colors
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m"

if [ $# -eq 0 ]; then
    printf "${RED}Usage: install.sh <package>${NC}\n" >&2
    exit 1
fi

pkg="$1"

if command -v pacman > /dev/null; then
    printf "${BLUE}Installing $pkg via pacman...${NC}\n"
    if sudo pacman -S "$pkg" --noconfirm; then
        printf "${GREEN}$pkg installed via pacman.${NC}\n"
        exit 0
    fi
    if command -v paru > /dev/null; then
        printf "${YELLOW}Trying paru...${NC}\n"
        if paru -S "$pkg" --noconfirm; then
            printf "${GREEN}$pkg installed via paru.${NC}\n"
            exit 0
        fi
    fi
    printf "${RED}Failed to install $pkg.${NC}\n" >&2
    exit 1
elif command -v brew > /dev/null; then
    printf "${BLUE}Installing $pkg via brew...${NC}\n"
    if brew install "$pkg"; then
        printf "${GREEN}$pkg installed via brew.${NC}\n"
        exit 0
    fi
    printf "${RED}Failed to install $pkg.${NC}\n" >&2
    exit 1
elif command -v nix > /dev/null; then
    printf "${BLUE}Installing $pkg via nix shell...${NC}\n"
    nix shell "nixpkgs#$pkg"
else
    printf "${RED}No supported package manager found (pacman, brew, nix).${NC}\n" >&2
    exit 1
fi
