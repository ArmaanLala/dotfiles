#!/usr/bin/env bash
# Clicked from waybar (modules.json -> custom/exit).
set -euo pipefail

options=("Lock" "Logout" "Suspend" "Reboot" "Shutdown")

# Hibernate needs somewhere to write the image. bread has swap but no resume
# device, so systemd would refuse it -- offering a button that can only fail is
# worse than not offering one.
[[ -r /sys/power/resume ]] && [[ "$(cat /sys/power/resume)" != "0:0" ]] &&
	options+=("Hibernate")

chosen=$(printf '%s\n' "${options[@]}" |
	fuzzel --dmenu --prompt "power: " --lines "${#options[@]}" --width 20) || exit 0

case "$chosen" in
# Through logind, so it takes the same path as hypridle's timer and the
# SUPER+SHIFT+L bind and only ever spawns one hyprlock.
Lock) loginctl lock-session ;;
# Compositor-agnostic: ends the session whether it came from uwsm/Hyprland or
# niri, instead of guessing which quit command exists.
Logout) loginctl terminate-session "${XDG_SESSION_ID:-self}" ;;
# Deliberate suspend. Nothing suspends on idle any more -- this button and
# the sleep key are the only paths to S3.
Suspend) systemctl suspend ;;
Reboot) systemctl reboot ;;
Shutdown) systemctl poweroff ;;
Hibernate) systemctl hibernate ;;
*) exit 0 ;;
esac
