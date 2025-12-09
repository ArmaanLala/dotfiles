#!/bin/sh
# Dotfiles installation script

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# Check for stow
command -v stow >/dev/null 2>&1 || { echo "Error: GNU stow not installed"; exit 1; }

# Stow dotfiles to home (--adopt will move conflicting files into dotfiles)
stow -v --adopt -d "$DOTFILES" -t "$HOME" .

# Symlink NixOS configs to /etc/nixos (requires sudo)
printf "Symlink .config/nixos to /etc/nixos? (requires sudo) [y/N]: "
read -r answer
if [ "$answer" = "y" ]; then
    [ -e /etc/nixos ] && sudo mv /etc/nixos "/etc/nixos.backup-$(date +%Y%m%d-%H%M%S)"
    sudo ln -s "$HOME/.config/nixos" /etc/nixos
    echo "Linked /etc/nixos -> $HOME/.config/nixos"
fi

echo "Done!"
