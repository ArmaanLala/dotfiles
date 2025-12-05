#!/bin/sh
# Generate /etc/hosts and ~/.ssh/config from hosts.txt

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOSTS_FILE="$SCRIPT_DIR/hosts.txt"
SSH_CONFIG="$HOME/.ssh/config"
ETC_HOSTS="/etc/hosts"

DEFAULT_USER="armaan"

if [ ! -f "$HOSTS_FILE" ]; then
    echo "Error: $HOSTS_FILE not found"
    exit 1
fi

# Generate SSH config
gen_ssh() {
    echo "# Generated from hosts.txt - do not edit directly"
    echo ""

    while IFS= read -r line || [ -n "$line" ]; do
        # Skip comments and empty lines
        case "$line" in
            \#*|"") continue ;;
        esac

        ip=$(echo "$line" | awk '{print $1}')
        host=$(echo "$line" | awk '{print $2}')
        user=$(echo "$line" | awk '{print $3}')
        [ -z "$user" ] && user="$DEFAULT_USER"

        echo "Host $host"
        echo "    HostName $ip"
        [ "$user" != "$DEFAULT_USER" ] && echo "    User $user"
        echo ""
    done < "$HOSTS_FILE"

    echo "Host *"
    echo "    User $DEFAULT_USER"
}

# Generate /etc/hosts
gen_etc_hosts() {
    echo "# Generated from hosts.txt - do not edit directly"
    echo "127.0.0.1        localhost"
    echo "::1              localhost"
    echo ""

    while IFS= read -r line || [ -n "$line" ]; do
        case "$line" in
            \#*|"") continue ;;
        esac

        ip=$(echo "$line" | awk '{print $1}')
        host=$(echo "$line" | awk '{print $2}')
        printf "%-15s  %s\n" "$ip" "$host"
    done < "$HOSTS_FILE"
}

case "$1" in
    ssh)
        gen_ssh
        ;;
    hosts)
        gen_etc_hosts
        ;;
    install)
        echo "Generating SSH config..."
        gen_ssh > "$SSH_CONFIG"
        chmod 600 "$SSH_CONFIG"
        echo "  -> $SSH_CONFIG"

        echo "Generating /etc/hosts (requires sudo)..."
        gen_etc_hosts | sudo tee "$ETC_HOSTS" > /dev/null
        echo "  -> $ETC_HOSTS"

        echo "Done!"
        ;;
    *)
        echo "Usage: $0 {ssh|hosts|install}"
        echo ""
        echo "  ssh      Print SSH config to stdout"
        echo "  hosts    Print /etc/hosts to stdout"
        echo "  install  Write both files to their destinations"
        exit 1
        ;;
esac
