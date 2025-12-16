#!/bin/bash

MICROBIN_URL="https://paste.armaanlala.tech"

# Colors
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

error() {
  printf "${RED}Error: $1${NC}\n" >&2
}

# Extract final URL from curl response
mbclean() {
  grep -i '^location:' | sed -E 's!location: .*/upload/!'"$MICROBIN_URL/p/"'!' | tr -d '\r'
}

upload_file() {
  curl -s -i -X POST "$MICROBIN_URL/upload" -F "file=@$1" -F "syntax_highlight=auto" | mbclean
}

upload_text() {
  curl -s -i -X POST "$MICROBIN_URL/upload" -F "content=$1" -F "syntax_highlight=auto" | mbclean
}

# Entry point
if [[ -n $1 ]]; then
  if [[ -f $1 ]]; then
    printf "${BLUE}Choose upload method for '$1':${NC}\n"
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
  # Read from stdin
  url=$(upload_text "@/dev/stdin")
else
  error "No input provided."
  printf "Usage:\n  $0 <text_string>\n  $0 <file_path>\n  command | $0\n"
  exit 1
fi

if [[ -n $url ]]; then
  printf "${GREEN}Uploaded: ${BLUE}$url${NC}\n"
else
  error "Upload failed or unexpected response."
  exit 1
fi

