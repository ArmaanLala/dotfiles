#!/bin/sh

GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m"

info() { printf "${BLUE}%s${NC}\n" "$1"; }
warn() { printf "${YELLOW}%s${NC}\n" "$1"; }
ok() { printf "${GREEN}%s${NC}\n" "$1"; }
fail() {
    printf "${RED}%s${NC}\n" "$1" >&2
    exit 1
}

if [ $# -eq 0 ]; then
    fail "Usage: install.sh <package>"
fi

pkg="$1"

if command -v pacman > /dev/null; then
    info "Installing $pkg via pacman..."
    if sudo pacman -S "$pkg" --noconfirm; then
        ok "$pkg installed via pacman."
        exit 0
    fi
    if command -v paru > /dev/null; then
        warn "Trying paru..."
        if paru -S "$pkg" --noconfirm; then
            ok "$pkg installed via paru."
            exit 0
        fi
    fi
    fail "Failed to install $pkg."
elif command -v brew > /dev/null; then
    info "Installing $pkg via brew..."
    if brew install "$pkg"; then
        ok "$pkg installed via brew."
        exit 0
    fi
    fail "Failed to install $pkg."
elif command -v nix > /dev/null; then
    info "Installing $pkg via nix profile..."
    if nix profile install "nixpkgs#$pkg"; then
        ok "$pkg installed via nix profile."
        exit 0
    fi
    fail "Failed to install $pkg."
else
    fail "No supported package manager found (pacman, brew, nix)."
fi
