#!/bin/bash
# MicroBin pastebin uploader - uploads files or text to a pastebin service

# Colors
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
NC="\033[0m"

MICROBIN_URL="https://paste.armaanlala.tech"

# Extract URL from response
mbclean() {
  grep -i '^location:' | sed -E 's!location: .*/upload/!'"$MICROBIN_URL/p/"'!' | tr -d '\r'
}

# Upload functions
upload_file() {
  echo -e "${BLUE}[INFO]${NC} Uploading file: $1"
  curl -s -i -X POST "$MICROBIN_URL/upload" -F "file=@$1" -F "syntax_highlight=auto" | mbclean
}

upload_text() {
  echo -e "${BLUE}[INFO]${NC} Uploading text content"
  curl -s -i -X POST "$MICROBIN_URL/upload" -F "content=$1" -F "syntax_highlight=auto" | mbclean
}

# Main logic
if [[ -n $1 ]]; then
  if [[ -f $1 ]]; then
    echo -e "${BLUE}[INFO]${NC} Detected a file: '$1'"
    echo -e "${CYAN}Choose upload method:${NC}"
    echo "1. File directly (default)"
    echo "2. File content as text"
    read -p "Enter choice (1 or 2): " choice
    choice=${choice:-1}
    case $choice in
      1) url=$(upload_file "$1") ;;
      2) url=$(upload_text "@$1") ;;
      *) echo -e "${RED}[ERROR]${NC} Invalid choice" >&2; exit 1 ;;
    esac
  elif [[ -d $1 ]]; then
    echo -e "${RED}[ERROR]${NC} '$1' is a directory. Only files or text input is supported." >&2
    exit 1
  else
    url=$(upload_text "$1")
  fi
elif [[ ! -t 0 ]]; then
  echo -e "${BLUE}[INFO]${NC} Reading from stdin..."
  url=$(upload_text "@/dev/stdin")
else
  echo -e "${RED}[ERROR]${NC} No input provided." >&2
  echo "Usage:"
  echo "  ./mb.sh <text_string>"
  echo "  ./mb.sh <file_path>"
  echo "  command | ./mb.sh"
  exit 1
fi

if [[ -n $url ]]; then
  echo -e "${GREEN}[SUCCESS]${NC} Uploaded successfully!"
  echo -e "${CYAN}URL:${NC} $url"
else
  echo -e "${RED}[ERROR]${NC} Upload failed or unexpected response." >&2
  exit 1
fi

