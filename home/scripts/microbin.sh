#!/bin/bash

MICROBIN_URL="https://paste.armaanlala.tech"

# Color codes
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
  echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Extract final URL from curl response
mbclean() {
  grep -i '^location:' | sed -E 's!location: .*/upload/!'"$MICROBIN_URL/p/"'!' | tr -d '\r'
}

upload_file() {
  info "Uploading file: $1"
  curl -s -i -X POST "$MICROBIN_URL/upload" -F "file=@$1" -F "syntax_highlight=auto" | mbclean
}

upload_text() {
  info "Uploading text content"
  curl -s -i -X POST "$MICROBIN_URL/upload" -F "content=$1" -F "syntax_highlight=auto" | mbclean
}

# Entry point
if [[ -n $1 ]]; then
  if [[ -f $1 ]]; then
    info "Detected a file: '$1'"
    echo "Choose upload method:"
    echo "1. Upload file directly (default)"
    echo "2. Upload file content as text"
    read -p "Enter choice (1 or 2): " choice
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
    error "Error: '$1' is a directory. Only files or text input is supported."
    exit 1
  else
    url=$(upload_text "$1")
  fi
elif [[ ! -t 0 ]]; then
  # Read from stdin
  info "Reading from stdin..."
  url=$(upload_text "@/dev/stdin")
else
  error "No input provided."
  echo "Usage:"
  echo "  ./mb.sh <text_string>"
  echo "  ./mb.sh <file_path>"
  echo "  command | ./mb.sh"
  exit 1
fi

if [[ -n $url ]]; then
  success "Uploaded successfully!"
  echo -e "${BLUE}URL:${NC} $url"
else
  error "Upload failed or unexpected response."
  exit 1
fi

