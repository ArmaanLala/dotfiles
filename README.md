# Dotfiles

Personal dotfiles managed with GNU stow.

## Quick Start

```bash
cd /path/to/dotfiles
./install.sh
```

## Manual Installation

### Home configs
```bash
stow -d /path/to/dotfiles -t $HOME home
```

### System configs (requires sudo)
```bash
sudo stow -d /path/to/dotfiles -t / system
```

## Uninstall

```bash
stow -D -d /path/to/dotfiles -t $HOME home
sudo stow -D -d /path/to/dotfiles -t / system
```

## SSH Key Management

SSH config is tracked in `home/.ssh/config`. Private keys are stored in gitignored `secrets/ssh/keys/`.

To deploy SSH keys to a new machine:
1. Copy keys to `secrets/ssh/keys/` (or transfer via USB/secure channel)
2. Manually copy: `cp secrets/ssh/keys/* ~/.ssh/`
3. Set permissions: `chmod 600 ~/.ssh/id_* && chmod 644 ~/.ssh/*.pub`

## Adding System Configs

Example: Add pacman.conf
```bash
sudo cp /etc/pacman.conf system/etc/pacman.conf
git add system/etc/pacman.conf
git commit -m "Add pacman.conf"
sudo stow -R -v -d /path/to/dotfiles -t / system
```

## Structure

- `home/` - User configs (stowed to $HOME)
- `system/` - System configs (stowed to /)
- `secrets/` - Local secrets (gitignored)
