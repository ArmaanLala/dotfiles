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
├── .config/          # XDG user configurations
│   ├── nvim/        # Neovim (submodule: github.com/ArmaanLala/nvim)
│   ├── nixos/       # NixOS configs (submodule: github.com/ArmaanLala/nixos)
│   ├── hypr/        # Hyprland compositor
│   ├── fish/        # Fish shell
│   ├── waybar/      # Status bar
│   └── ...
├── scripts/         # Personal utility scripts
│   └── dotstow      # Installation/update script
├── wallpapers/      # Desktop wallpapers
└── README.md
```

## Manual Installation

### Initialize submodules
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

## SSH Key Management

SSH config is tracked in `.config/ssh/config`. Private keys are stored in gitignored `secrets/ssh/keys/`.

To deploy SSH keys to a new machine:
1. Copy keys to `secrets/ssh/keys/`
2. Manually copy: `cp secrets/ssh/keys/* ~/.ssh/`
3. Set permissions: `chmod 600 ~/.ssh/id_* && chmod 644 ~/.ssh/*.pub`

## Migration from Old Structure

This repository was restructured from separate `home/` and `system/` directories. The old structure is available in the `backup-before-restructure` branch.
