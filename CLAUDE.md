# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository that manages Linux desktop/server configurations using **GNU stow** for symlinking and **git submodules** for external configurations. The system supports both desktop environments (Hyprland, Niri) and NixOS server configurations.

## Essential Commands

### Installation & Setup
```bash
# Complete installation (recommended)
./scripts/dotstow

# Manual installation steps
git submodule update --init --recursive
stow -v --adopt -d /path/to/dotfiles -t $HOME .
sudo ln -s $HOME/.config/nixos /etc/nixos  # Optional for NixOS
```

### Submodule Management
```bash
# Update all submodules
git submodule update --remote

# Update specific submodule
cd .config/nvim && git pull origin main && cd ../.. && git add .config/nvim
```

### NixOS System Management
```bash
# Rebuild system (after linking to /etc/nixos)
sudo nixos-rebuild switch --flake /etc/nixos#atlas
nh os switch  # Using nh helper
```

### Uninstallation
```bash
stow -D -d /path/to/dotfiles -t $HOME .
sudo rm /etc/nixos
```

## Architecture & Structure

### Core Design Principles
- **XDG Compliance**: All configurations stored in `.config/`
- **Stow-based**: Uses GNU stow for symlink management
- **Modular**: Each application has separate configuration directory
- **Git Submodules**: Complex configs (nvim, nixos) managed as external repositories
- **Multi-environment**: Supports Hyprland, Niri, multiple terminals

### Key Directories
- `.config/`: XDG user configurations (stowed to `$HOME/.config/`)
- `scripts/`: Utility scripts including main `dotstow` installer
- `wallpapers/`: Desktop wallpaper collection (~73MB)

### Git Submodules
- `.config/nvim` → https://github.com/ArmaanLala/nvim (Neovim configuration)
- `.config/nixos` → https://github.com/ArmaanLala/nixos (NixOS system configurations)

### Critical Files
- `scripts/dotstow`: Main installation script with error handling and cleanup
- `.config/hypr/hyprland.conf`: Primary Wayland compositor configuration
- `.config/nixos/`: NixOS flake-based system configurations for multiple hosts

## Desktop Environment Configuration

### Supported Compositors
- **Hyprland**: Primary tiling window manager (`.config/hypr/`)
- **Niri**: Alternative tiling compositor (`.config/niri/`)

### Terminal Emulators
- **Ghostty**: Modern terminal with blur effects (`.config/ghostty/`)
- **Alacritty**: GPU-accelerated with Nord theme (`.config/alacritty/`)

### Key Applications
- **Waybar**: Status bar with CPU, memory, battery monitoring
- **Fuzzel**: Application launcher with Dracula theme
- **Fish**: Shell configuration (minimal setup)

## NixOS Integration

### Flake Structure
- **Hosts**: atlas (media server), weed, photos (NAS), proton (VPN), lenix, webserv
- **Modules**: Located in `.config/nixos/modules/` for reusable system components
- **Services**: Media server stack (*arr applications), Jellyfin, Immich, VPN configs

### Package Management
- System packages managed via NixOS flakes
- Arch Linux fallback: `scripts/install.sh` (pacman → paru)

## Development Workflow

### Making Changes
1. Edit configurations in `.config/` directories
2. Test changes with `stow -v --adopt -d . -t $HOME .`
3. For submodule changes: commit in submodule, then update parent repo
4. For NixOS changes: `sudo nixos-rebuild switch --flake /etc/nixos#<host>`

### Repository History
- Recently restructured from `home/`/`system/` directories to unified `.config/`
- Old structure available in `backup-before-restructure` branch
- `scripts/dotstow` includes cleanup for old restructure artifacts

## Utility Scripts

Located in `scripts/`:
- `dotstow`: Main installer with git pull, submodule updates, stow deployment
- `gen-hosts.sh`: Generate SSH config and `/etc/hosts` from `hosts.txt`
- `fzf-ps.sh`: Interactive process selector using fzf
- `microbin.sh`: Upload files to pastebin service
- `wallpaper.sh`: Set random wallpaper via swaybg
- `install.sh`: Arch Linux package installer (pacman/paru)

## Dependencies

### Required
- **GNU stow**: Core symlink management
- **Git**: Repository and submodule management

### Optional
- **NixOS**: For system configuration management
- **Fish shell**: Enhanced shell with completions
- **Hyprland/Niri**: Desktop environments
- **fzf**: For interactive scripts

## Important Notes

- Repository uses `.config/` as the stow root directory
- Submodules are independent repositories with their own versioning
- NixOS configs support multiple hosts and can be linked to `/etc/nixos`
- Installation script (`dotstow`) handles common failure scenarios and cleanup
- All configurations follow XDG Base Directory specification