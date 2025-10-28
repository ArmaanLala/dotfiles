#!/bin/sh
# Package installer that tries pacman first, then falls back to paru (AUR helper)

# Colors
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
NC="\033[0m"

if [ $# -eq 0 ]; then
	echo -e "${RED}[ERROR]${NC} Please provide a package name as an argument."
	exit 1
fi

pkg="$1"
echo -e "${BLUE}[INFO]${NC} Installing package: $pkg"

echo -e "${BLUE}[INFO]${NC} Attempting to install using pacman..."
sudo pacman -S "$pkg" --noconfirm
if [ $? -eq 0 ]; then
	echo -e "${GREEN}[SUCCESS]${NC} $pkg installed successfully via pacman."
	exit 0
else
	echo -e "${YELLOW}[WARNING]${NC} $pkg not found in official repositories. Trying paru..."
fi

paru -S "$pkg" --noconfirm
if [ $? -eq 0 ]; then
	echo -e "${GREEN}[SUCCESS]${NC} $pkg installed successfully via paru."
	exit 0
else
	echo -e "${RED}[ERROR]${NC} Failed to install $pkg using both pacman and paru."
	exit 1
fi
