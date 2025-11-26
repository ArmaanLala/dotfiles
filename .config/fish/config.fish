if status is-interactive
    # Commands to run in interactive sessions can go here
    
    # Editor and pager
    set -gx EDITOR nvim
    set -gx VISUAL nvim

    # Add common directories to PATH
    # fish_add_path $HOME/.local/bin
end

# Conditional aliases based on tool availability
if type -q zoxide
    alias cd="z"
end

alias pman="sudo pacman -S"
alias c="clear"
alias v="nvim"

if type -q bat
    alias cat="bat"
end

if type -q rg
    alias grep="rg --color=auto"
end


if type -q distrobox
    alias ds="distrobox"
end

alias fk="sudo !!"
alias mv="mv -i"
alias rm="rm -Iv"
alias df="df -h"
alias du="du -h -d 1"
alias k="killall"
alias p="ps aux | grep $1"
alias yay="paru"
alias lz="lazygit"
alias i="$HOME/scripts/install.sh"
alias mb="$HOME/scripts/microbin.sh"

if type -q eza
    alias l="eza --color=auto --icons -h "
    alias ll="eza --color=auto --icons -lh"
    alias ls="eza --color=auto --icons -h"
    alias la="eza --color=auto --icons -lah"
end


# Initialize tools if available
if type -q batman
    batman --export-env | source
end

if type -q zoxide
    zoxide init fish | source
end

if type -q starship
    starship init fish | source
end
