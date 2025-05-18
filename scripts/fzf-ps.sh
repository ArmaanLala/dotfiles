#!/bin/sh

PS=$(which ps)
ps_preview_fmt="pid,ppid=PARENT,user,%cpu,rss=RSS_IN_KB,start=START_TIME,command"

PS_OUTPUT=$(
	ps -A -o pid,command | fzf --multi \
		--prompt="Processes> " \
		--ansi \
		--header-lines=1 \
		--preview="$(which ps) -o $ps_preview_fmt -p {1} || echo 'Cannot preview {1} because it exited.'" \
		--preview-window="bottom:4:wrap" \
		--style="full"
)

echo "$PS_OUTPUT" | awk '{print $1;}'
