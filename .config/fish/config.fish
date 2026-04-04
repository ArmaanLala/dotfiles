if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx GOPATH "$HOME/go"

set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx LESSHISTFILE "$XDG_CACHE_HOME/less_history"
set -gx PYTHON_HISTORY "$XDG_DATA_HOME/python/history"

fish_add_path "$HOME/scripts"
fish_add_path "$HOME/scripts/apple"
fish_add_path "$HOME/.local/bin"

#TODO if macos set $home/scripts/apple

alias c="clear"
alias cat="bat"
alias cd="z"
alias df="df -h"
alias du="du -h -d 1"
alias i="$HOME/scripts/install.sh"
alias jump="ssh -J jumpbox"
alias k="killall"
alias l="eza --color=auto --icons -h"
alias la="eza --color=auto --icons -lah"
alias ll="eza --color=auto --icons -lh"
alias ls="eza --color=auto --icons -h"
alias lz="lazygit"
alias gps="git pull && git submodule update --init --recursive"
alias mb="$HOME/scripts/microbin.sh"
alias mv="mv -i"
alias p="ps aux | grep"
alias pman="sudo pacman -S"
alias rm="rm -Iv"
alias v="nvim"
alias yay="paru"
alias fmt="treefmt --config-file $XDG_CONFIG_HOME/treefmt.toml"
alias pk="pkill -9 -f"

# tools
batman --export-env | source
zoxide init fish | source
starship init fish | source
