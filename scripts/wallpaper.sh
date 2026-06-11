#!/bin/sh

GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m"

folder="${2:-$HOME/wallpapers}"
input_image="$1"

if [ -n "$input_image" ] && [ -f "$input_image" ]; then
    random_image="$input_image"
    printf "${BLUE}Setting wallpaper: $(basename "$input_image")${NC}\n"
else
    random_image=$(find "$folder" -maxdepth 1 \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) | shuf -n 1)
    if [ -z "$random_image" ]; then
        printf "${RED}Error: No wallpapers found in %s${NC}\n" "$folder" >&2
        exit 1
    fi
    printf "${BLUE}Setting random wallpaper: $(basename "$random_image")${NC}\n"
fi

pkill -x swaybg 2>/dev/null
swaybg --image "$random_image" &
printf "${GREEN}Wallpaper set successfully${NC}\n"
