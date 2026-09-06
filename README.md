# Dotfiles

Personal dotfiles managed with GNU stow and git submodules.

## Quick Start

```bash
cd /path/to/dotfiles
./scripts/dotstow
```

This will:

1. Pull the latest dotfiles from the repository
2. Update git submodules (nvim, nixos)
3. Stow all configs to `$HOME`
4. Optionally symlink `.config/nixos` to `/etc/nixos`

## Structure

```
dotfiles/
├── .config/               # XDG user configs (stowed to ~/.config)
│   ├── nvim/              # Neovim      (submodule: github.com/ArmaanLala/nvim)
│   ├── nixos/             # NixOS       (submodule: github.com/ArmaanLala/nixos)
│   ├── hypr/              # Hyprland compositor
│   ├── niri/              # niri compositor
│   ├── waybar/            # Status bar (config + modules.json + style.css + scripts/)
│   ├── fish/              # Fish shell (config + functions/)
│   ├── ghostty/           # Terminal
│   ├── fuzzel/            # App launcher
│   ├── walker/            # App launcher (alt)
│   ├── dunst/             # Notifications
│   ├── git/ignore         # Global gitignore (core.excludesfile)
│   └── treefmt.toml       # treefmt formatter config
├── scripts/               # Utility scripts (stowed to ~/scripts, on PATH)
│   ├── dotstow            # Install / update script
│   ├── install.sh         # Package install wrapper (pacman/brew/nix)
│   ├── microbin.sh        # Paste-to-microbin helper
│   └── wallpaper.sh       # Set / randomise wallpaper
├── wallpapers/            # Desktop wallpapers (stowed to ~/wallpapers)
├── .stow-local-ignore     # Paths stow must not link into ~
└── README.md
```

## Manual Installation

### Initialize submodules

Both submodules use SSH URLs, so SSH auth to GitHub must be set up first.

```bash
git submodule update --init --recursive
```

### Stow to home directory

```bash
stow -v --adopt -d /path/to/dotfiles -t $HOME .
```

### Link NixOS configs (optional)

```bash
sudo ln -s $HOME/.config/nixos /etc/nixos
```

## Uninstall

```bash
# Remove stowed dotfiles
stow -D -d /path/to/dotfiles -t $HOME .

# Remove NixOS symlink
sudo rm /etc/nixos
```

## Submodules

### Update submodules

```bash
git submodule update --remote
```

### Update specific submodule

```bash
cd .config/nvim
git pull origin main
cd ../..
git add .config/nvim
git commit -m "update: nvim submodule"
```

## NixOS

After symlinking `/etc/nixos`:

```bash
# Rebuild system
sudo nixos-rebuild switch --flake /etc/nixos#atlas

# Or using nh
nh os switch
```

## Migration from Old Structure

This repository was restructured from separate `home/` and `system/` directories. The old structure is available in the `backup-before-restructure` branch.
