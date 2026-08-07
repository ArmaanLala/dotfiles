if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx GOPATH "$HOME/go"
set -gx LESSHISTFILE "$HOME/.cache/less_history"
set -gx PYTHON_HISTORY "$HOME/.local/share/python/history"

fish_add_path "$HOME/scripts"
fish_add_path "$HOME/.local/bin"
if test (uname) = Darwin
    fish_add_path "$HOME/scripts/apple"
end

alias bv="xcodebuild build -scheme All | xcbeautify"
alias c="clear"
alias cl="claude"
alias clr="claude --resume"
alias df="df -h"
alias du="du -h -d 1"
alias glow="glow -p"
alias jump="ssh -J jumpbox"
alias kk="killall"
alias l="eza --color=auto --icons -h"
alias la="eza --color=auto --icons -lah"
alias ll="eza --color=auto --icons -lh"
alias ls="eza --color=auto --icons -h"
alias lz="lazygit"
alias gps="git pull && git submodule update --init --recursive"
alias mv="mv -i"
alias ov="open Virtualization.xcworkspace"
alias p="ps aux | grep"
alias rm="rm -Iv"
alias rgi="rg -i"
alias v="nvim"
alias fmt="treefmt --config-file $HOME/.config/treefmt.toml"
alias pk="pkill -9 -f"

if command -v pacman >/dev/null
    alias pman="sudo pacman -S"
    alias yay="paru"
end

if command -v bat >/dev/null
    alias cat="bat"
end

if command -v zoxide >/dev/null
    alias cd="z"
end

# tools
batman --export-env | source
zoxide init fish | source
starship init fish | source
