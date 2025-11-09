if status is-interactive
    # Commands to run in interactive sessions can go here
    
    # Editor and pager
    set -gx EDITOR nvim
    set -gx VISUAL nvim

    # Add common directories to PATH
    # fish_add_path $HOME/.local/bin
end

alias cd="z" 
alias pman="sudo pacman -S" 
alias c="clear" 
alias v="nvim" 
alias cat="bat" 
alias grep="rg --color=auto" 
alias shell="exec $SHELL -l" 
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
alias l="eza --color=auto --icons -h "
alias ll="eza --color=auto --icons -lh"
alias ls="eza --color=auto --icons -h"
alias la="eza --color=auto --icons -lah"

batman --export-env | source
zoxide init fish | source
starship init fish | source
