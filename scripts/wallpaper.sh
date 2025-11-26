#!/bin/sh
# Sets wallpaper using swaybg - uses provided image or selects random one from ~/wallpapers

# Colors
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
NC="\033[0m"

folder="$HOME/wallpapers"
input_image="$1"

echo -e "${BLUE}[INFO]${NC} Wallpaper Setter"

if [ -n "$input_image" ] && [ -f "$input_image" ]; then
	echo -e "${BLUE}[INFO]${NC} Using provided image: $input_image"
	wallpaper="$input_image"
else
	echo -e "${BLUE}[INFO]${NC} Selecting random wallpaper..."
	if [ ! -d "$folder" ]; then
		echo -e "${RED}[ERROR]${NC} Wallpaper folder not found: $folder"
		exit 1
	fi
	
	cd "$folder" || exit
	wallpaper=$(ls *.png *.jpg 2>/dev/null | shuf -n 1)
	
	if [ -z "$wallpaper" ]; then
		echo -e "${RED}[ERROR]${NC} No wallpaper images found in $folder"
		exit 1
	fi
	
	echo -e "${CYAN}Selected:${NC} $wallpaper"
	wallpaper="$folder/$wallpaper"
fi

echo -e "${BLUE}[INFO]${NC} Setting wallpaper with swaybg..."
swaybg --image "$wallpaper" &
echo -e "${GREEN}[SUCCESS]${NC} Wallpaper set successfully!"
