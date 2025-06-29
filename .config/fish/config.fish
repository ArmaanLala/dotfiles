if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias cd="z" 
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

zoxide init fish | source
starship init fish | source
