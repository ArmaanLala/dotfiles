#!/usr/bin/env bash
set -euo pipefail

options=("Lock" "Logout" "Suspend" "Reboot" "Shutdown")

[[ -r /sys/power/resume ]] && [[ "$(cat /sys/power/resume)" != "0:0" ]] &&
	options+=("Hibernate")

chosen=$(printf '%s\n' "${options[@]}" |
	fuzzel --dmenu --prompt "power: " --lines "${#options[@]}" --width 20) || exit 0

case "$chosen" in
Lock) loginctl lock-session ;;
Logout) loginctl terminate-session "${XDG_SESSION_ID:-self}" ;;
Suspend) systemctl suspend ;;
Reboot) systemctl reboot ;;
Shutdown) systemctl poweroff ;;
Hibernate) systemctl hibernate ;;
*) exit 0 ;;
esac
