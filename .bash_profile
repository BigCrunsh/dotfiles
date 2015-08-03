# colors

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# history

shopt -s histappend

export HISTCONTROL=erasedups
export HISTSIZE=10000
export HISTIGNORE=' *'

if tty 1>/dev/null
  then
    bind Space:magic-space
    bind '"\e[A"':history-search-backward
    bind '"\e[B"':history-search-forward
fi

# includes

source ~/.bash_prompt
source ~/.common.shellrc
