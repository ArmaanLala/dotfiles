#!/usr/bin/env sh

killall -q waybar

while pgrep -x waybar >/dev/null; do sleep 0.2; done

nohup waybar >/dev/null 2>&1 &
