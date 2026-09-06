# Dotfiles Audit

Running record of cleanup work on this repo. Supersedes the old `report.md`.

Last pass: 2026-09-06

---

## Done

### Repo / git

- **`.config/git/ignore`** was a broken symlink into a stale
  `/nix/store/…-home-manager-files` path (home-manager residue captured by
  `stow --adopt`). Replaced with a real global-ignore file.
- **`.config/git/ignore.hm-backup`** — home-manager backup cruft. Deleted.
- **`.gitignore`** — dropped the stale `.config/zsh/.zcompdump` line (no zsh
  config in the repo).
- **`.gitmodules`** — added `branch = main` to both submodules so
  `git submodule update --remote` tracks a defined branch.
- **`.stow-local-ignore`** added — keeps `README.md`, `audit.md`, `report.md`
  and VCS files out of `$HOME` (this replaces stow's built-in default list, so
  the standard entries are repeated in it).
- **`report.md`** removed (stale; it also got symlinked to `~/report.md`).
- **`README.md`** — refreshed the structure tree, noted the SSH prerequisite
  for submodule init.

### waybar

- Removed the dead **`config.jsonc`** — waybar loads `config` first, and only
  `config` lines up with `modules.json` / `style.css` / `power-menu.sh`.
- **`modules.json`** trimmed to the modules actually placed in the bar. Removed
  `custom/empty`, `custom/tools`, `custom/updates` (pacman-only),
  `custom/appmenuicon` (dup of `custom/appmenu`), `keyboard-state`,
  `niri/language`, `bluetooth`, `user`, `backlight`.
- Launcher unified on **fuzzel** — `custom/appmenu` no longer shells out to
  `wofi` (not installed; hypr/niri/nixos all use fuzzel).
- `custom/appmenu` / `custom/exit` paths de-`~`'d to absolute.
- Dropped the `clock` `on-click: ags -t calendar` (ags not installed).
- Merged the two restart scripts — kept `scripts/waybar-restart.sh`
  (kill + wait-for-exit + relaunch), deleted the near-duplicate `waybar.sh`.
- Fixed `power-menu.sh`'s stale `custom/power` → `custom/exit` comment.

### fish

- `functions/home.fish` — replaced the hardcoded `/Users/...` / `/home/...`
  branch with `cp -r $argv $HOME`.
- `config.fish` — moved the Xcode-only `bv` / `ov` aliases behind a
  `test (uname) = Darwin` guard (next to the existing pacman guard).
- `functions/notify.fish` — now portable: `notify-send` on Linux, `osascript`
  on macOS.

### scripts

- `install.sh` — rewritten with small `info/warn/ok/fail` helpers; `$pkg` no
  longer interpolated into `printf` format strings; the nix branch now does
  `nix profile install` (persistent, matches the other branches) instead of
  dropping into `nix shell`.
- `microbin.sh` — `$1` / `$0` / `$url` moved out of `printf` format strings
  into `%s` args. Shebang `#!/bin/bash` → `#!/usr/bin/env bash` (NixOS has no
  `/bin/bash`, so the script failed to exec).

### misc

- `walker/config.toml` — removed the `archlinuxpkgs` action block (Arch-only).
- `fuzzel.ini` — labelled the palette (`# Dracula`).

---

## Deferred / needs a decision

- **`.git` is ~72 MB** for ~14 MB of tracked content — the rest is deleted
  wallpaper blobs + the pre-restructure tree. A `git filter-repo` pass would
  reclaim it but rewrites history (force-push, breaks
  `backup-before-restructure`). Left alone.
- **`origin/what`** — abandoned branch (March 2026, diverged 13/29 from main).
  Candidate for deletion.
- **`walker/`** appears unused — nothing launches walker (hypr/niri/waybar all
  use fuzzel; `elephant` is started in `hyprland.conf`). Kept for now;
  `themes/default.{toml,css}` are walker's "AUTO GENERATED — DO NOT EDIT"
  defaults with no local changes.
- **Monitor config** in `hyprland.conf` / `niri/config.kdl` is host-specific
  and shared across hosts (the thinkpad inherits DP-1/DP-2 it lacks). Not
  touched — hyprland/niri are off-limits for now; `dunstrc` already documents
  the per-host-include pattern to follow.
- Hardcoded absolute paths (`/home/armaan/scripts/wallpaper.sh` etc.) are
  intentional and left as-is.
- `treefmt.toml` carries formatter blocks for languages absent from this repo
  (rs/go/c/py/lua/yaml) — fine if it's the intended global config.
- `ghostty/config` — `background-blur = 20` with `background-opacity = 0.9`
  (blur barely visible at near-full opacity). Left as-is; may be intentional.
