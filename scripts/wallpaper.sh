#!/bin/sh

# Colors
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m"

folder="$HOME/wallpapers"
input_image="$1"

if [ -n "$input_image" ] && [ -f "$input_image" ]; then
	random_image="$input_image"
	printf "${BLUE}Setting wallpaper: $(basename "$input_image")${NC}\n"
else
	cd "$folder" || {
		printf "${RED}Error: Wallpaper directory not found${NC}\n" >&2
		exit 1
	}
	random_image=$(ls *.png *.jpg *.jpeg 2>/dev/null | shuf -n 1)
	if [ -z "$random_image" ]; then
		printf "${RED}Error: No wallpapers found in $folder${NC}\n" >&2
		exit 1
	fi
	printf "${BLUE}Setting random wallpaper: $random_image${NC}\n"
fi

# Set wallpaper
swaybg --image "$random_image" &
printf "${GREEN}Wallpaper set successfully${NC}\n"
