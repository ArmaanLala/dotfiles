# Dotfiles

Personal dotfiles, managed with GNU stow and git submodules.

```bash
./scripts/dotstow          # pull, update submodules, stow to ~, optionally link /etc/nixos
```

Submodules use SSH URLs, so GitHub SSH auth must be set up first. Manual:

```bash
git submodule update --init --recursive
stow -v --adopt -d "$PWD" -t "$HOME" .
sudo ln -s ~/.config/nixos /etc/nixos          # optional
```

## Structure

```
.config/
  nvim/          Neovim        (submodule: github.com/ArmaanLala/nvim)
  nixos/         NixOS flake   (submodule: github.com/ArmaanLala/nixos)
  hypr/ niri/    compositors
  waybar/        status bar
  fish/          shell (config + functions/)
  ghostty/ fuzzel/ dunst/ git/ treefmt.toml
scripts/         stowed to ~/scripts (on PATH)
  dotstow        install / update
  install.sh     package-install wrapper (pacman/brew/nix)
  microbin.sh    paste to bin.armaanlala.tech
  wallpaper.sh   set / randomise wallpaper
  nixup trumpet  remote NixOS fleet helpers (see .config/nixos)
wallpapers/      stowed to ~/wallpapers
.stow-local-ignore   paths stow must not link into ~
```

Hardcoded absolute paths (`/home/armaan/scripts/…`) are intentional.

## Submodules

```bash
git submodule update --remote        # bump both to their tracked branch
git -C .config/nvim pull && git add .config/nvim && git commit -m "nvim"
```
