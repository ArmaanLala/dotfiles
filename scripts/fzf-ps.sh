#!/bin/sh
# Interactive process selector using fzf with detailed preview

# Colors
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
NC="\033[0m"

ps_preview_fmt="pid,ppid=PARENT,user,%cpu,rss=RSS_IN_KB,start=START_TIME,command"

echo -e "${BLUE}[INFO]${NC} Process Selector"

PS_OUTPUT=$(
	ps -A -o pid,command |
	awk '{if(NR==1) {print "\033[1;36m" $0 "\033[0m"} else {print}}' |
	fzf --multi \
		--prompt="${CYAN}Processes>${NC} " \
		--ansi \
		--header-lines=1 \
		--preview="echo -e '${CYAN}Process Details:${NC}\n'; ps -o $ps_preview_fmt -p {1} || echo -e '${RED}[ERROR]${NC} Process exited'" \
		--preview-window="bottom:4:wrap"
)

if [ -z "$PS_OUTPUT" ]; then
	echo -e "${YELLOW}[WARNING]${NC} No process selected."
	exit 0
fi

SELECTED_PIDS=$(echo "$PS_OUTPUT" | awk '{print $1;}')
echo -e "${GREEN}[SUCCESS]${NC} Selected PIDs: $SELECTED_PIDS"
echo "$SELECTED_PIDS"
