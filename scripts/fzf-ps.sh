#!/bin/sh

# Colors
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m"

PS=$(which ps)
ps_preview_fmt="pid,ppid=PARENT,user,%cpu,rss=RSS_IN_KB,start=START_TIME,command"

if ! command -v fzf >/dev/null 2>&1; then
	printf "${RED}Error: fzf not found${NC}\n" >&2
	exit 1
fi

PS_OUTPUT=$(
	ps -A -o pid,command | fzf --multi \
		--prompt="Processes> " \
		--ansi \
		--header-lines=1 \
		--preview="$(which ps) -o $ps_preview_fmt -p {1} || echo 'Cannot preview {1} because it exited.'" \
		--preview-window="bottom:4:wrap" \
		--style="full"
)

if [ -n "$PS_OUTPUT" ]; then
	echo "$PS_OUTPUT" | awk '{print $1;}'
fi
