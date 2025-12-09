#!/bin/sh

# Read package name from argument
if [ $# -eq 0 ]; then
	echo "Please provide a package name as an argument."
	exit 1
fi

pkg="$1"

# Try installing with pacman first
echo "Attempting to install $pkg using pacman..."
sudo pacman -S "$pkg" --noconfirm
if [ $? -eq 0 ]; then
	echo "$pkg installed successfully via pacman."
	exit 0
else
	echo "$pkg not found in official repositories. Trying paru..."
fi

# If pacman failed, try installing with paru
paru -S "$pkg" --noconfirm
if [ $? -eq 0 ]; then
	echo $?
	echo "$pkg installed successfully via paru."
	exit 0
else
	echo "Failed to install $pkg using both pacman and paru."
	exit 1
fi
