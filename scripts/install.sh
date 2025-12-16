#!/bin/sh

# Colors
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m"

# Read package name from argument
if [ $# -eq 0 ]; then
	printf "${RED}Please provide a package name as an argument.${NC}\n" >&2
	exit 1
fi

pkg="$1"

# Try installing with pacman first
printf "${BLUE}Installing $pkg via pacman...${NC}\n"
sudo pacman -S "$pkg" --noconfirm
if [ $? -eq 0 ]; then
	printf "${GREEN}$pkg installed successfully via pacman.${NC}\n"
	exit 0
else
	printf "${YELLOW}$pkg not found in official repositories. Trying paru...${NC}\n"
fi

# If pacman failed, try installing with paru
paru -S "$pkg" --noconfirm
if [ $? -eq 0 ]; then
	printf "${GREEN}$pkg installed successfully via paru.${NC}\n"
	exit 0
else
	printf "${RED}Failed to install $pkg using both pacman and paru.${NC}\n" >&2
	exit 1
fi
