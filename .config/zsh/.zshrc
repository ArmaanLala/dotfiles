# main zsh settings. env in ~/.zprofile
# read second

# source global shell alias & variables files
[ -f "$XDG_CONFIG_HOME/shell/alias" ] && source "$XDG_CONFIG_HOME/shell/alias"

# load modules
zmodload zsh/complist
autoload -U compinit && compinit
autoload -U colors && colors
autoload -U promptinit && promptinit

# autoload -U tetris # main attraction of zsh, obviously

# cmp opts
zstyle ':completion:*' menu select # tab opens cmp menu
zstyle ':completion:*' special-dirs true # force . and .. to show in cmp menu
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33 # colorize cmp menu
# zstyle ':completion:*' file-list true # more detailed list
zstyle ':completion:*' squeeze-slashes false # explicit disable to allow /*/ expansion

# main opts
setopt append_history inc_append_history share_history # better history
# on exit, history appends rather than overwrites; history is appended as soon as cmds executed; history shared across sessions
setopt auto_menu menu_complete # autocmp first menu match
setopt autocd # type a dir to cd
setopt auto_param_slash # when a dir is completed, add a / instead of a trailing space
setopt no_case_glob no_case_match # make cmp case insensitive
setopt globdots # include dotfiles
setopt extended_glob # match ~ # ^
setopt interactive_comments # allow comments in shell
unsetopt prompt_sp # don't autoclean blanklines
stty stop undef # disable accidental ctrl s

# history opts
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$XDG_CACHE_HOME/zsh_history" # move histfile to cache
HISTCONTROL=ignoreboth # consecutive duplicates & commands starting with space are not saved

PROMPT='%(?.%F{green}√.%F{red}%? X)%f %B%F{240}%1~%f%b > '

# fzf setup
source <(fzf --zsh) # allow for fzf history widget
# binds
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey '^R' fzf-history-widget

eval "$(zoxide init zsh)"

# autosuggestions
# requires zsh-autosuggestions
source "$XDG_CONFIG_HOME/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# syntax highlighting
# requires zsh-syntax-highlighting package
source "$XDG_CONFIG_HOME/zsh/plugins/zsh-highlighting/zsh-syntax-highlighting.zsh"
