# Dotfiles Improvement Report

## 1. Repo Structure & Organization

### Critical Issues
- **No `.gitignore`** — at minimum, `fish_variables`, `*.swp`, `.DS_Store` should be ignored. `fish_variables` contains machine-specific universal variable state that changes automatically during fish sessions; it pollutes `git status` on every machine.
- **No `.stowrc`** — without one, stow will try to symlink `README.md`, `scripts/`, and `wallpapers/` as top-level home directory entries. A `.stowrc` with `--ignore=README.md` and appropriate exclusions prevents this.
- **Arch vs NixOS split is undocumented** — the repo has Arch-specific artifacts (`install.sh`, wikiman arch source, walker archlinuxpkgs, pacman alias) alongside a full NixOS flake. Nothing in the README or the code marks which parts apply where.
- **SSH submodule URLs** — both submodules (`nvim`, `nixos`) use `git@github.com:` URLs. `git submodule update --init` fails on any machine where SSH isn't set up yet, which is the exact moment you're bootstrapping. The README doesn't mention this prerequisite.

### Improvements
- Add `.gitignore` covering `fish_variables`, swap files, `.DS_Store`
- Add `.stowrc` to control what stow links
- Document Arch vs NixOS split in README, or use a machine-type directory structure
- Add HTTPS fallback note to README Quick Start, or switch submodule URLs to HTTPS
- Add `branch = main` to both `.gitmodules` entries

---

## 2. Fish Shell (`config.fish`)

### Issues
- **`~/scripts/apple` added to PATH unconditionally** — the `#TODO if macos` comment acknowledges this but the path is added anyway. Wrap in `if test (uname) = Darwin`.
- **Arch-only aliases** — `alias pman="sudo pacman -S"` and `alias yay="paru"` silently alias to missing commands on every non-Arch machine.
- **`alias cd="z"` and `alias cat="bat"` break if tools are absent** — on a fresh machine before tools are installed, core commands stop working. Guard with `command -v zoxide > /dev/null` etc., or use conditional functions.
- **Redundant XDG exports** — `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_CACHE_HOME` are set to their spec defaults. Drop them entirely.
- **`fish_variables` shouldn't be tracked** — this file is fish's internal machine-specific state. Remove from repo and add to `.gitignore`.
- **`conf.d/fish_frozen_key_bindings.fish`** — fish itself says "we recommend you delete this file." Remove it and the `.bak` alongside it.
- **Machine-specific aliases in shared config** — `alias i="$HOME/scripts/install.sh"` and `alias mb="..."` are personal; they belong in a local override file, not shared dotfiles.

---

## 3. Terminal Emulators

### Alacritty (`alacritty.toml`)
- **Entire `[keyboard]` section is Alacritty defaults** — ~50 lines reproducing built-in bindings verbatim. Delete the whole section.
- **`[mouse.bindings]` middle-click is a default** — remove.
- **`[window.class]`, `working_directory = "None"`, `cursor.vi_mode_style = "None"`** — all defaults. Remove.
- **`WINIT_X11_SCALE_FACTOR = "1"`** — X11-specific, HiDPI-defeating, machine-specific. Remove from shared config.
- After removing dead defaults, this file goes from ~165 lines to ~40.

### Ghostty (`config`)
- **`background-blur = 20` with `background-opacity = 1`** — blur has no visual effect at full opacity. Either lower opacity or remove the blur line.
- **`clipboard-read/write = allow`** — these are recent Ghostty defaults; verify and remove if so.
- **The `shift+enter` keybind** — add a comment explaining the `ESC+CR` Neovim workaround so it's not mysterious.

---

## 4. Window Managers

### Hyprland (`hyprland.conf`)
- **Hard-coded `/home/armaan/scripts/wallpaper.sh`** — use `~/scripts/wallpaper.sh`.
- **Monitor config is machine-specific** — `DP-1`, `DP-2`, `HDMI-A-1` with resolutions and pixel positions belong in a sourced `~/.config/hypr/monitors.conf` that is gitignored and created per-machine. Add `source = ~/.config/hypr/local.conf` at the bottom for any other machine-local overrides.
- **Dead `master {}` block** — layout is `dwindle`, so this block is never read. Remove.
- **`active_opacity = 1.0` / `inactive_opacity = 1.0`** — defaults. Remove.
- **`rounding_power = 2` with `rounding = 0`** — rounding_power is meaningless without rounding. Remove.
- **`misc.disable_hyprland_logo = false`** — default. Remove.
- **Vim key ordering inconsistency** — J maps right and K maps up, which is backwards from Vim convention (and inconsistent with the niri config). Either fix to standard H/J/K/L = left/down/up/right or leave and document the intentional deviation.

### Niri (`config.kdl`)
- **Monitor config same issue** — machine-specific values should be split out.
- **Duplicate launcher bindings** — `Mod+Space` spawns `wofi` and `Mod+R` spawns `fuzzel`. Pick one.
- **`wofi` vs `fuzzel` inconsistency** — `waybar/modules.json` `custom/appmenu` uses `wofi -show drun`, hyprland uses `fuzzel`. Pick one launcher across the whole setup.
- **Dead Wezterm window-rule** — no Wezterm elsewhere in config. Add a comment or remove.
- **Redundant `preset-column-widths` + `default-column-width`** — both set to `proportion 0.8`. Keep only `default-column-width`.
- **Empty `struts {}` block** — remove.
- **Mixed tabs/spaces** — `eDP-1` block uses tabs while everything else uses spaces.
- **Commented dead spawn lines** — remove `// not installed` entries.

---

## 5. Waybar

### Structural Problem
Two parallel configs exist (`config` and `config.jsonc`) targeting different compositors. Consider consolidating into one `config.jsonc` that lists both compositor modules (waybar skips inapplicable ones at runtime), with a shared `modules.json` and `style.css`.

### config.jsonc
- **Both compositor modules in one bar** — `niri/workspaces` AND `hyprland/workspaces` in `modules-left`, `niri/window` AND `hyprland/window` in `modules-center`. Acceptable as a portability strategy but should be intentional — move the primary compositor's modules first.
- **Dead module definitions** — `memory`, `temperature`, `power-profiles-daemon`, `keyboard-state`, `idle_inhibitor` are defined but never placed in any module position. Remove them.

### modules.json
- **`custom/appmenu` and `custom/appmenuicon` are identical** — same format, same on-click. Remove one.
- **`custom/empty`** — renders an empty string for layout padding. Use CSS margin/padding instead.
- **`pulseaudio` has `"format-icons": {}`** — empty object means `{icon}` in format strings renders nothing. Populate or remove `{icon}`.
- **`custom/updates` is pacman-specific** — silently does nothing on NixOS. Remove or add an `exec-if: command -v pacman` guard.
- **`niri/language` format `"/ K {short}"`** — the `/ K` prefix looks like a template artifact.

### style.css
- **`background-image: url('/usr/share/icons/cachyos.svg')`** — hard-coded CachyOS-specific absolute path. Will silently break on any other distro. Remove.
- **`font-size: 4` on `#custom-appmenu`** — missing unit. Should be `4px`.
- **No CSS variables** — colors repeated 5–10 times each. Add a `:root {}` block with `--bg`, `--surface`, `--accent`, `--text` and reference them throughout.
- **`border-radius: 0px` repeated on every rule** — set once globally or remove.
- **`#workspaces` vs `#niri-workspaces` selector mismatch** — active/hover rules target Hyprland's selector; on niri the active state styling never applies.
- **`config` has four `margin-*: 0` lines** — all-zero margins are the default. Remove.

---

## 6. Launchers & Utilities

### Fuzzel (`fuzzel.ini`)
- Add a `# Dracula` comment above the `[colors]` block.
- Add explicit `terminal=ghostty` under `[main]`.
- Document whether `dpi-aware=no` is intentional.

### Walker (`config.toml`)
- **230 lines of mostly defaults** — strip to only non-default values (~60 lines).
- Remove the `archlinuxpkgs` provider block if on NixOS.
- Fix triple `ctrl+i` conflict in clipboard actions.

### Lazygit (`config.yml`)
- **Empty file** — delete it and the `lazygit/` directory from the repo, or populate with actual customizations.

### Wikiman (`wikiman.conf`)
- `sources = man, arch` — change to `sources = man` as the safe universal default, or add a comment noting the Arch dependency.

---

## 7. Scripts

### `wallpaper.sh`
- **Multiple swaybg processes** — add `pkill -x swaybg 2>/dev/null` before launching.
- **`ls *.png *.jpg` glob antipattern** — breaks on filenames with spaces. Replace with `find`.
- Accept wallpaper directory as an optional argument: `folder="${1:-$HOME/wallpapers}"`.

### `install.sh`
- **Arch-only** — rename to `arch-install.sh` and guard with `command -v pacman || exit 1`, or make distro-aware.
- Fix `if [ $? -eq 0 ]` pattern to `if sudo pacman -S "$pkg" --noconfirm; then`.
- Add `command -v paru` guard before falling back to paru.

### `dotstow`
- **`--adopt` is destructive** — add a dry-run step before the real stow.
- Remove the stale `home/` migration cleanup block.
- Separate `git pull` into an optional step or add a `--no-pull` flag.

### `fzf-ps.sh`
- Remove unused `PS` variable and unused color variables (`GREEN`, `BLUE`, `YELLOW`, `NC`).
- Replace `$(which ps)` in the preview string with plain `ps`.
- Add a usage comment explaining the intended pipe pattern.
- `--style="full"` requires fzf 0.53+; drop it or add a version guard.

### `microbin.sh`
- Make the URL overridable: `MICROBIN_URL="${MICROBIN_URL:-https://paste.armaanlala.tech}"`.
- Quote `$1` in `error()`.
- Add `--max-time 15` to curl calls.
- Remove unused `YELLOW` variable.

---

## 8. NixOS (`nixos/`)

### Critical
- **`disko-config.nix` is unmodified template boilerplate** — it has `/home/user` subvolumes, `/test` mount points, `"20M"` swap sizes from the disko README example. Replace with the actual drapion disk layout.
- **`PasswordAuthentication = true`** in `common.nix` — SSH keys are already configured. Set to `false` in common and override only where genuinely needed.

### High Priority
- **Username `"armaan"` hard-coded in 10+ places** — define `username = "armaan"` in `flake.nix`, pass via `specialArgs`, and use `${username}` everywhere.
- **`claude-code` installed twice on drapion** — `desktop.nix` adds it as user package, `drapion/configuration.nix` adds it as system package. Remove one.
- **`allowUnfree = true` set twice** — set in `common.nix` and again in `drapion/configuration.nix`. Remove the duplicate.
- **`deploy.sh` is redundant with colmena** — iterates all hosts including local ones, lacks rollback. Remove or restrict to non-colmena hosts.

### Medium Priority
- **`autoUpgrade` on drapion (unstable)** — move out of `common.nix` into a dedicated module that only servers import.
- **Duplicate `thinkpad` hostname** — two IPs map to `thinkpad` in `networking.hosts`. Remove the stale one.
- **`open-webui.nix` hard-codes `drapion` hostname** — make it a module option.
- **NFS TrueNAS address `10.0.0.160`** — repeated as a literal. Define once and reference.
- **`colmena` passed as `specialArgs`** just to install it as a desktop package — use `devShells` instead.

---

## Priority Summary

| Priority | Area | Action |
|----------|------|--------|
| Critical | NixOS | Replace disko-config.nix template with real disk layout |
| Critical | NixOS | Set `PasswordAuthentication = false` in common.nix |
| Critical | waybar/style.css | Remove `/usr/share/icons/cachyos.svg` hard-coded path |
| High | fish | Remove `fish_variables` from repo, add to `.gitignore` |
| High | fish | Gate `scripts/apple` PATH behind macOS check |
| High | fish | Remove/guard Arch-only aliases |
| High | alacritty | Delete entire `[keyboard]` section (all defaults) |
| High | hyprland | Fix hard-coded `/home/armaan` path; split monitor config to `local.conf` |
| High | niri | Split monitor config to machine-local file |
| High | NixOS | Centralize username via `specialArgs` |
| High | NixOS | Fix `claude-code` and `allowUnfree` duplicates |
| High | scripts | `wallpaper.sh`: fix swaybg stacking, fix `ls` glob |
| High | dotstow | Add dry-run before `--adopt`, remove migration cleanup block |
| Medium | waybar | Add CSS variables for colors in `style.css` |
| Medium | waybar | Fix `#workspaces` vs `#niri-workspaces` selector mismatch |
| Medium | waybar | Remove dead module definitions in `config.jsonc` |
| Medium | niri | Decide on one launcher (fuzzel vs wofi) |
| Medium | walker | Strip to non-default settings only (~60 lines) |
| Medium | repo | Add `.gitignore`, `.stowrc` |
| Medium | repo | Add SSH prerequisite to README |
| Low | ghostty | Fix blur + full opacity contradiction |
| Low | lazygit | Delete empty config file |
| Low | wikiman | Change `sources = man, arch` to `sources = man` |
| Low | microbin.sh | Make URL overridable via env var |
| Low | fzf-ps.sh | Remove unused variables, add usage comment |
