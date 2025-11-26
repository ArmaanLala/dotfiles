#!/bin/bash
# Finds and deletes Apple internal network interfaces with primate-related names

GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m"

echo -e "${BLUE}[INFO]${NC} Searching for primate interfaces..."
primates=$(networksetup -listallnetworkservices | grep -Ei "Koba|Chimp|Kanzi|Koko|Debug USB")

if [ -z "$primates" ]; then
    echo -e "${YELLOW}[WARN]${NC} No primate interfaces found."
    exit 0
fi

echo -e "${BLUE}[INFO]${NC} Found interfaces:"
echo "$primates"

while IFS= read -r line; do
    sudo networksetup -deletepppoeservice "$line"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[SUCCESS]${NC} Deleted: $line"
    else
        echo -e "${RED}[ERROR]${NC} Failed to delete: $line"
    fi
done <<< "$primates"

echo -e "${GREEN}[SUCCESS]${NC} All primate interfaces processed."
