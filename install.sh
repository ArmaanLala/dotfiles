#!/bin/sh
# GNU Stow dotfiles installation script (POSIX sh compatible)

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# Check for stow
command -v stow >/dev/null 2>&1 || { echo "Error: GNU stow not installed"; exit 1; }

# Prompt for system configs
printf "Stow system configs to /? (requires sudo) [y/N]: "
read -r sys_answer
[ "$sys_answer" = "y" ] && sudo stow -v -d "$DOTFILES" -t / system

# Prompt for home configs
printf "Stow home configs to \$HOME? [y/N]: "
read -r home_answer
[ "$home_answer" = "y" ] && stow -v -d "$DOTFILES" -t "$HOME" home

echo "Done! Use 'stow -D <package>' to unstow."
