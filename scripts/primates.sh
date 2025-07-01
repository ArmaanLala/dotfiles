#!/bin/bash

primates=$(networksetup -listallnetworkservices | grep -Ei "Koba|Chimp|Kanzi|Koko|Debug USB")

while IFS= read -r line; do
	sudo networksetup -deletepppoeservice "$line"
	echo "Deleted interface $line"
done <<< "$primates"
