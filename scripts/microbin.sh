#!/usr/bin/env bash

MICROBIN_URL="${MICROBIN_URL:-https://bin.armaanlala.tech}"

GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m"

error() {
    printf "${RED}Error: %s${NC}\n" "$1" >&2
}

mbclean() {
    grep -i '^location:' | sed -E 's!location: .*/upload/!'"$MICROBIN_URL/p/"'!' | tr -d '\r'
}

upload_file() {
    curl -s -i --max-time 60 -X POST "$MICROBIN_URL/upload" -F "file=@$1" -F "syntax_highlight=auto" | mbclean
}

upload_text() {
    curl -s -i --max-time 60 -X POST "$MICROBIN_URL/upload" -F "content=$1" -F "syntax_highlight=auto" | mbclean
}

if [[ -n $1 ]]; then
    if [[ -f $1 ]]; then
        printf "${BLUE}Choose upload method for '%s':${NC}\n" "$1"
        printf "1. Upload file directly (default)\n"
        printf "2. Upload file content as text\n"
        printf "Enter choice (1 or 2): "
        read -r choice
        choice=${choice:-1}
        case $choice in
        1)
            url=$(upload_file "$1")
            ;;
        2)
            url=$(upload_text "@$1")
            ;;
        *)
            error "Invalid choice"
            exit 1
            ;;
        esac
    elif [[ -d $1 ]]; then
        error "'$1' is a directory. Only files or text input is supported."
        exit 1
    else
        url=$(upload_text "$1")
    fi
elif [[ ! -t 0 ]]; then
    url=$(upload_text "@/dev/stdin")
else
    error "No input provided."
    printf "Usage:\n  %s <text_string>\n  %s <file_path>\n  command | %s\n" "$0" "$0" "$0"
    exit 1
fi

if [[ -n $url ]]; then
    printf "${GREEN}Uploaded: ${BLUE}%s${NC}\n" "$url"
else
    error "Upload failed or unexpected response."
    exit 1
fi
