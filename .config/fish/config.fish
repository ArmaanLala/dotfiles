if status is-interactive
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

if test (uname) = Darwin
    alias bv="xcodebuild build -scheme All | xcbeautify"
    alias ov="open Virtualization.xcworkspace"
end

if command -v bat >/dev/null
    alias cat="bat"
end

if status is-interactive
    if command -v batman >/dev/null
        batman --export-env | source
    end

    if command -v zoxide >/dev/null
        zoxide init fish --cmd cd | source
        alias z="cd"
        alias zi="cdi"
    end

    if command -v starship >/dev/null
        starship init fish | source
    end
end
