# environment
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx GOPATH "$HOME/go"

set -gx LESSHISTFILE "$XDG_CACHE_HOME/less_history"
set -gx PYTHON_HISTORY "$XDG_DATA_HOME/python/history"

set -gx LESS "R --use-color -Dd+r -Du+b"
set -gx LESS_TERMCAP_mb (printf '\e[1;31m')
set -gx LESS_TERMCAP_md (printf '\e[1;36m')
set -gx LESS_TERMCAP_me (printf '\e[0m')
set -gx LESS_TERMCAP_so (printf '\e[01;44;33m')
set -gx LESS_TERMCAP_se (printf '\e[0m')
set -gx LESS_TERMCAP_us (printf '\e[1;32m')
set -gx LESS_TERMCAP_ue (printf '\e[0m')


# path
fish_add_path "$HOME/scripts"
fish_add_path "$GOPATH/bin"


# aliases
alias v="nvim"
alias c="clear"

if type -q zoxide
    alias cd="z"
end

if type -q bat
    alias cat="bat"
end

if type -q rg
    alias grep="rg --color=auto"
end

if type -q eza
    alias l="eza --color=auto --icons -h"
    alias ll="eza --color=auto --icons -lh"
    alias ls="eza --color=auto --icons -h"
    alias la="eza --color=auto --icons -lah"
end

if type -q distrobox
    alias ds="distrobox"
end

alias pman="sudo pacman -S"
alias yay="paru"

alias mv="mv -i"
alias rm="rm -Iv"

alias df="df -h"
alias du="du -h -d 1"
alias k="killall"
alias p="ps aux | grep"

alias lz="lazygit"

alias i="$HOME/scripts/install.sh"
alias mb="$HOME/scripts/microbin.sh"

if type -q ssh
    alias jump="ssh -J jumpbox"
end


# tools
if type -q batman
    batman --export-env | source
end

if type -q zoxide
    zoxide init fish | source
end

if type -q starship
    starship init fish | source
end


# platform
if test (uname) = "Darwin"
    if test -d "$HOME/.local/bin"
        fish_add_path "$HOME/.local/bin"
    end

    if test -d "$HOME/.lmstudio/bin"
        fish_add_path "$HOME/.lmstudio/bin"
    end
end
export PATH="$HOME/.local/bin:$PATH"
