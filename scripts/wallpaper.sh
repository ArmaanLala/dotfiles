#!/bin/sh

folder="$HOME/wallpapers"

input_image="$1"

if [ -n "$input_image" ] && [ -f "$input_image" ]; then
	random_image="$input_image"
else
	cd "$folder" || exit
	random_image=$(ls *.png *.jpg | shuf -n 1)
fi

wal -i "$random_image" &
swaybg --image "$random_image" &
pkill waybar
setsid -f waybar
