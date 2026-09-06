#!/usr/bin/env sh
# Restart waybar: kill any running instances, wait for them to exit, relaunch.

killall -q waybar

while pgrep -x waybar >/dev/null; do sleep 0.2; done

nohup waybar >/dev/null 2>&1 &
